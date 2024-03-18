local lspzero_status, lsp_zero = pcall(require, "lsp-zero")

if not lspzero_status then
  return
end

local mason_status, mason = pcall(require, "mason")

if not mason_status then
  return
end

local masonlspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")

if not masonlspconfig_status then
  return
end

local mason_nvim_dap_status, mason_nvim_dap = pcall(require, "mason-nvim-dap")

if not mason_nvim_dap_status then
  return
end

lsp_zero.on_attach(function(client, bufnr)
  -- keybindings
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false
  }) 
end)

mason.setup()
mason_nvim_dap.setup({
  ensure_installed = { "javadbg" },
  handlers = {
    function(config)
      mason_nvim_dap.default_setup(config)
    end,
  },
  automatic_installation = true,
})
mason_lspconfig.setup({
  ensure_installed = {
    "jdtls",
    "html",
    "cssls",
    "tailwindcss",
    "clojure_lsp",
    "tsserver",
  },
  automatic_installation = true,
  handlers = {
    lsp_zero.default_setup,
    jdtls = lsp_zero.noop,
  },
})

