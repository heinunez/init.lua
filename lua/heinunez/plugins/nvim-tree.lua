local setup, nvimtree = pcall(require, "nvim-tree")

if not setup then
  return
end

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
  update_focused_file = {
    enable = true
  },
  view = {
    side = "right",
    width = 40,
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})

