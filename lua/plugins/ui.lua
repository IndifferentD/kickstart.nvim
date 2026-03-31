return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        styles = {
          italic = false,
          transparency = false,
        },
      }
      vim.cmd.colorscheme 'rose-pine'
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
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
      popupmenu = {
        enabled = true,
      },
      presets = {
        bottom_search = false,
        command_palette = false,
      },
    },
  },
}
