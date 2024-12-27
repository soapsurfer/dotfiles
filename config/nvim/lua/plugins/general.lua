-- just too lazy to do proper sorting lol
return {
  'rodjek/vim-puppet',
  'lukas-reineke/indent-blankline.nvim',
  'lervag/vimtex',
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  }

  -- -- Convert stuff to comment
  -- use {
  --   'numToStr/Comment.nvim',
  --   config = function()
  --     require('Comment').setup()
  --   end
  -- }

