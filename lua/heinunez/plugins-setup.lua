local ensure_packer = function()
  local fn = vim.fn
  local  install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require,"packer")
if not status then
  return
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  use("folke/tokyonight.nvim")
  
  -- tmux & split window navigation
  use("christoomey/vim-tmux-navigator")
  use("szw/vim-maximizer") -- maximizes and restores current window

  -- essential
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")

  use("numToStr/Comment.nvim")

  -- file explorer
  use("nvim-tree/nvim-tree.lua")

  -- icons
  use("kyazdani42/nvim-web-devicons")

  -- statusline
  use("nvim-lualine/lualine.nvim") 

  -- fuzzy finding
  use({"nvim-telescope/telescope-fzf-native.nvim", run = "make"}) -- dep
  use("nvim-lua/plenary.nvim") -- dep
  use({"nvim-telescope/telescope.nvim", branch = "0.1.x"})

  -- lsp
  use({"williamboman/mason.nvim", opts = {
    registries = {
      "github:nvim-java/mason-registry",
			"github:mason-org/mason-registry",
    }
  }})
  use("williamboman/mason-lspconfig.nvim")
  use({"VonHeikemen/lsp-zero.nvim", branch = "v3.x"})
  use({"neovim/nvim-lspconfig", requires = "hrsh7th/cmp-nvim-lsp", ensure_dependencies = true})
  use({"hrsh7th/nvim-cmp", requires = "L3MON4D3/LuaSnip", ensure_dependencies = true})
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("mfussenegger/nvim-jdtls")
  use("mfussenegger/nvim-dap")
  use("jay-babu/mason-nvim-dap.nvim")

  -- treesiter
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use("windwp/nvim-autopairs")

  -- git
  use("lewis6991/gitsigns.nvim")
  use("tpope/vim-fugitive")

  if packer_bootstrap then
    require("packer").sync()
  end
end)

