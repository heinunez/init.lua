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

local config = {
  cmd = { 
    vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
    "-data", ws_dir
  },
  root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "automatic",
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = vim.fn.expand("~/.jabba/jdk/amazon-corretto@1.8.292-10.1")
          },
          {
            name = "JavaSE-17",
            path = vim.fn.expand("~/.jabba/jdk/openjdk@1.17.0")
          }
        }
      },
      saveActions = { organizeImports = true },
    }
  },
  init_options = {
    bundles = bundles;
  }
}

jdtls.start_or_attach(config)

