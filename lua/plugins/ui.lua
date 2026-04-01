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
        highlight_groups = {
          NoiceCmdlinePopupCmdline = { fg = 'text', bg = 'highlight_low' },
          NoiceCmdlinePopupBorderCmdline = { fg = 'love', bg = 'highlight_low' },
          NoiceCmdlinePopupTitleCmdline = { fg = 'love', bg = 'highlight_low', bold = true },
          NoiceCmdlineIconCmdline = { fg = 'love', bg = 'highlight_low' },
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
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.snacks_animate = false
    end,
    opts = function()
      local telescope = require 'telescope.builtin'

      return {
        bigfile = {
          enabled = true,
        },
        indent = {
          enabled = true,
        },
        input = {
          enabled = true,
        },
        notifier = {
          enabled = true,
        },
        dashboard = {
          enabled = true,
          preset = {
            header = [[

███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
            keys = {
              { icon = ' ', key = 'f', desc = 'Find File', action = function() telescope.find_files() end },
              {
                icon = ' ',
                key = 'n',
                desc = 'New File',
                action = function()
                  vim.cmd 'ene'
                  vim.cmd 'startinsert'
                end,
              },
              { icon = ' ', key = 'g', desc = 'Find Text', action = function() telescope.live_grep() end },
              { icon = ' ', key = 'r', desc = 'Recent Files', action = function() telescope.oldfiles() end },
              {
                icon = ' ',
                key = 'c',
                desc = 'Config',
                action = function()
                  telescope.find_files { cwd = vim.fn.stdpath 'config' }
                end,
              },
              { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = function() vim.cmd 'Lazy' end },
              { icon = ' ', key = 'q', desc = 'Quit', action = function() vim.cmd 'qa' end },
            },
          },
          sections = {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
            { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = { 1, 1 } },
            { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = { 1, 1 } },
            { section = 'startup' },
          },
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        format = {
          cmdline = {
            opts = {
              win_options = {
                winhighlight = {
                  Normal = 'NoiceCmdlinePopupCmdline',
                  FloatBorder = 'NoiceCmdlinePopupBorderCmdline',
                  FloatTitle = 'NoiceCmdlinePopupTitleCmdline',
                },
              },
            },
          },
        },
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
