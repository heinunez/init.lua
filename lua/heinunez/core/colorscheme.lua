local theme_status, theme = pcall(require, "tokyonight")

if not theme_status then
  return
end

theme.setup({
  transparent = true,
})

local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status then
  print("colorscheme not found")
  return
end

