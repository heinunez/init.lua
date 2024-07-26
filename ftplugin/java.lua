local jdtls_status, jdtls = pcall(require, "jdtls")

if not jdtls_status then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local ws_dir = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name

local bundles = {
  vim.fn.glob("~/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", 1),
}

vim.list_extend(bundles, vim.split(vim.fn.glob("~/.local/share/java-test/server/*.jar", 1), "\n"))

local get_sdk_env_name = function(folder)
  local envs = {
    ["1.8"] = "JavaSE-1.8",
    ["11"] = "JavaSE-11",
    ["17"] = "JavaSE-17",
    ["1.17"] = "JavaSE-17",
    ["21"] = "JavaSE-21"
  }

  local env_name = nil

  local starts_with = function(str, start)
    return str:sub(1, #start) == start
  end

  local clean_vendor = function(str)
    local i = string.find(str, "@")

    if i == nil then
      return str
    end

    return str:sub(i + 1, #str)
  end

  for i, v in pairs(envs) do
    if starts_with(clean_vendor(folder), i) then
      env_name = v
      break
    end
  end

  return env_name  
end

local sdk_runtimes = function(base_path)
  local sdk_dir = vim.fn.expand(base_path)
  local sdk_folder_list = io.popen('find ' ..sdk_dir.. " -mindepth 1 -maxdepth 1 -type d -printf '%f\\n' | sort -r")
  local sdks = {}

  if sdk_folder_list == nil then
    return sdks
  end

  for sdk_version in sdk_folder_list:lines() do
    local env_name = get_sdk_env_name(sdk_version)

    if env_name ~= nil then
      table.insert(sdks, {name=env_name, path= sdk_dir..sdk_version})
    end
  end

  sdk_folder_list:close()
  return sdks
end

local all_runtimes = function()
  local add = function(t1, t2)
    for i = 1, #t2 do
      table.insert(t1, t2[i])
    end
  end

  local sdkman_runtimes = sdk_runtimes("~/.sdkman/candidates/java/")
  local jabba_runtimes = sdk_runtimes("~/.jabba/jdk/")
  
  add(sdkman_runtimes, jabba_runtimes)

  return sdkman_runtimes
end

local runtimes = all_runtimes()

local is_file_exist = function(path)
  local f = io.open(path, 'r')
  return f ~= nil and io.close(f)
end

local get_lombok_javaagent = function()
  local lombok_dir = vim.fn.expand('~/.m2/repository/org/projectlombok/lombok/')
  local lombok_versions = io.popen('ls -1 "' .. lombok_dir .. '" | sort -r')
  if lombok_versions ~= nil then
    local lb_i, lb_versions = 0, {}
    for lb_version in lombok_versions:lines() do
      lb_i = lb_i + 1
      lb_versions[lb_i] = lb_version
    end
    lombok_versions:close()
    if next(lb_versions) ~= nil then
      local lombok_jar = vim.fn.expand(string.format('%s%s/*.jar', lombok_dir, lb_versions[1]))
      if is_file_exist(lombok_jar) then
        return string.format('--jvm-arg=-javaagent:%s', lombok_jar)
      end
    end
  end
  return ''
end

local get_cmd = function()
  local cmd = { 
    vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
  }

  local lombok_javaagent = get_lombok_javaagent()
  if(lombok_javaagent ~= "") then
    table.insert(cmd, lombok_javaagent)
  end

  table.insert(cmd, "-data")
  table.insert(cmd, ws_dir)

  return cmd  
end

local config = {
  cmd = get_cmd(),
  root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "automatic",
        runtimes = runtimes,
      },
      saveActions = { organizeImports = true },
    }
  },
  init_options = {
    bundles = bundles;
  }
}

jdtls.start_or_attach(config)

