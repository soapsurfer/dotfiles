-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'rodjek/vim-puppet'

  -- Telescope - Fuzzy file searching
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} , 
    {'nvim-treesitter/nvim-treesitter'} }
  }

  -- Convert stuff to comment
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

  -- Colors
  use 'morhetz/gruvbox'
end)
