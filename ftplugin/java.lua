local jdtls_status, jdtls = pcall(require, "jdtls")

if not jdtls_status then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local ws_dir = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name

local bundles = {
  vim.fn.glob("~/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", 1),
};
vim.list_extend(bundles, vim.split(vim.fn.glob("~/.local/share/java-test/server/*.jar", 1), "\n"))

local runtimes = vim.fn.json_decode(
  vim.fn.readfile(
    vim.fn.expand("~/.config/java/jdks.json")
  )
)

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

