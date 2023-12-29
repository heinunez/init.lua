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

lsp_zero.on_attach(function(client, bufnr)
  -- keybindings
  lsp_zero.default_keymaps({buffer = bufnr}) 
end)

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "html",
    "cssls",
    "tailwindcss",
  },
  automatic_installation = true,
  handlers = {
    lsp_zero.default_setup,
    jdtls = lsp_zero.noop,
  },
})

