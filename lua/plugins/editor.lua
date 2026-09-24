return {
  'NMAC427/guess-indent.nvim',
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      auto_create_enabled = true,
      auto_restore_enabled = true,
      auto_save_enabled = true,
      auto_session_suppress_dirs = {
        vim.fn.expand '~',
        '/',
      },
    },
  },
}
