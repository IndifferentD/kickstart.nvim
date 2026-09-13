return {
  {
    'b0o/incline.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local incline = require 'incline'
      incline.setup(opts)
      vim.api.nvim_create_autocmd('DiagnosticChanged', {
        group = vim.api.nvim_create_augroup('incline-diagnostics', { clear = true }),
        callback = function()
          incline.refresh()
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        group = 'incline-diagnostics',
        pattern = 'GitSignsUpdate',
        callback = function()
          incline.refresh()
        end,
      })
    end,
    opts = {
      window = {
        placement = { horizontal = 'right', vertical = 'top' },
      },
      render = function(props)
        local counts = vim.diagnostic.count(props.buf)
        local icons = vim.g.have_nerd_font and { '', '', '', '' } or { 'E', 'W', 'I', 'H' }
        local result = {}
        for severity, name in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
          local count = counts[severity] or 0
          if count > 0 then
            result[#result + 1] = { icons[severity] .. ' ' .. count .. ' ', group = 'Diagnostic' .. name }
          end
        end
        local git = vim.b[props.buf].gitsigns_status_dict or {}
        local git_icons = vim.g.have_nerd_font and { '', '', '' } or { '+', '~', '-' }
        local has_diagnostics = #result > 0
        for index, kind in ipairs { 'added', 'changed', 'removed' } do
          local count = git[kind] or 0
          if count > 0 then
            if has_diagnostics then
              result[#result + 1] = { '│ ', group = 'Comment' }
              has_diagnostics = false
            end
            local groups = { 'GitSignsAdd', 'GitSignsChange', 'GitSignsDelete' }
            result[#result + 1] = { git_icons[index] .. ' ' .. count .. ' ', group = groups[index] }
          end
        end
        return #result > 0 and result or nil
      end,
    },
  },
  {
    'petertriho/nvim-scrollbar',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      excluded_buftypes = { 'terminal', 'nofile', 'prompt', 'quickfix' },
      handlers = { diagnostic = true },
    },
  },
  {
    'nickkadutskyi/jb.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('jb').setup { disable_hl_args = { italic = true } }
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('jb-noice-colors', { clear = true }),
        pattern = 'jb',
        callback = function()
          for group, target in pairs {
            NoiceCmdlinePopupCmdline = 'NormalFloat',
            NoiceCmdlinePopupBorderCmdline = 'FloatBorder',
            NoiceCmdlinePopupTitleCmdline = 'FloatTitle',
            NoiceCmdlineIconCmdline = 'Special',
          } do
            vim.api.nvim_set_hl(0, group, { link = target })
          end
        end,
      })
      vim.o.background = 'dark'
      vim.cmd.colorscheme 'jb'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        styles = {
          italic = false,
          transparency = false,
        },
        highlight_groups = {
          NeoTreeGitModified = { fg = 'foam' },
          NeoTreeGitUntracked = { fg = 'rose' },
          NeoTreeGitUnstaged = { fg = 'love' },
          NeoTreeGitStaged = { fg = 'pine' },
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
          width = {
            max = 0.7,
          },
        },
        styles = {
          notification = {
            wo = {
              wrap = true,
            },
          },
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
              {
                icon = ' ',
                key = 'f',
                desc = 'Find File',
                action = function()
                  telescope.find_files()
                end,
              },
              {
                icon = ' ',
                key = 'n',
                desc = 'New File',
                action = function()
                  vim.cmd 'ene'
                  vim.cmd 'startinsert'
                end,
              },
              {
                icon = ' ',
                key = 'g',
                desc = 'Find Text',
                action = function()
                  telescope.live_grep()
                end,
              },
              {
                icon = ' ',
                key = 'r',
                desc = 'Recent Files',
                action = function()
                  telescope.oldfiles()
                end,
              },
              {
                icon = ' ',
                key = 'c',
                desc = 'Config',
                action = function()
                  telescope.find_files { cwd = vim.fn.stdpath 'config' }
                end,
              },
              {
                icon = '󰒲 ',
                key = 'l',
                desc = 'Lazy',
                action = function()
                  vim.cmd 'Lazy'
                end,
              },
              {
                icon = ' ',
                key = 'q',
                desc = 'Quit',
                action = function()
                  vim.cmd 'qa'
                end,
              },
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
