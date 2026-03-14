return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        style = 'night',
        transparent = false,
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          render_limit = 16,
          done_ttl = 3,
          skip_history = false,
        },
      },
    },
  },
}
