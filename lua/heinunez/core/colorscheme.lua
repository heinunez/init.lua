local opt = vim.opt
local theme_setup, theme = pcall(require, "onedarkpro");

if not theme_setup then
  return;
end

theme.setup({
  styles = {
    keywords = "bold,italic",
    comments = "italic",
    functions = "italic",
    conditionals = "italic",
  },
  options = {
    transparency = true,
  }
})

local status, _ = pcall(vim.cmd, "colorscheme onedark")
if not status then
  print("colorscheme not found")
  return
end

