local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status, lazy = pcall(require,"lazy")
if not status then
  return
end

return lazy.setup({
  "olimorris/onedarkpro.nvim",
  
  -- tmux & split window navigation
  "christoomey/vim-tmux-navigator",
  "szw/vim-maximizer", -- maximizes and restores current window

  -- essential
  "tpope/vim-surround",
  "vim-scripts/ReplaceWithRegister",

  "numToStr/Comment.nvim",

  -- file explorer
  "nvim-tree/nvim-tree.lua",

  -- icons
  "nvim-tree/nvim-web-devicons",

  -- statusline
  "nvim-lualine/lualine.nvim",

  -- fuzzy finding
  {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}, -- dep
  "nvim-lua/plenary.nvim", -- dep
  {"nvim-telescope/telescope.nvim", branch = "0.1.x"},

  -- lsp
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
  {"neovim/nvim-lspconfig", dependencies = {"hrsh7th/cmp-nvim-lsp"}},
  {"hrsh7th/nvim-cmp", dependencies = {
      {"L3MON4D3/LuaSnip", dependencies = {"rafamadriz/friendly-snippets", "molleweide/LuaSnip-snippets.nvim"}}, 
      "saadparwaiz1/cmp_luasnip"
    }
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "mfussenegger/nvim-jdtls",
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",

  -- treesiter
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  "windwp/nvim-autopairs",

  -- git
  "lewis6991/gitsigns.nvim",
  "tpope/vim-fugitive",

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
        require"alpha".setup(require"alpha.themes.startify".config)
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  "yamatsum/nvim-cursorline",
  -- templates
  {
    "Futarimiti/spooky.nvim", dependencies = {"nvim-telescope/telescope.nvim"}
  },
})

