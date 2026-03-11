return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      require('nvim-dap-virtual-text').setup {
        commented = true, -- Show virtual text alongside comment
      }
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dap_python = require 'dap-python'
      dap_python.setup 'uv'
      -- dap_python.test_runner = "pytest"
      dapui.setup {
        layouts = {
          {
            position = 'left',
            size = 75, -- ширина левой панели
            elements = {
              { id = 'scopes', size = 0.50 },
              { id = 'breakpoints', size = 0.15 },
              { id = 'stacks', size = 0.15 },
              { id = 'watches', size = 0.20 },
            },
          },
          {
            position = 'bottom',
            size = 15, -- высота нижней панели
            elements = {
              { id = 'repl', size = 0.50 },
              { id = 'console', size = 0.50 },
            },
          },
        },
      }

      vim.fn.sign_define('DapBreakpoint', {
        text = '',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapBreakpointRejected', {
        text = '',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapStopped', {
        text = '', -- or "→"
        texthl = 'DiagnosticSignWarn',
        linehl = 'Visual',
        numhl = 'DiagnosticSignWarn',
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      -- Automatically open/close DAP UI
      -- dap.listeners.after.event_initialized['dapui_config'] = function()
      --   dapui.open()
      -- end

      -- local opts = { noremap = true, silent = true }

      -- Toggle breakpoint
      vim.keymap.set('n', '<leader>db', function()
        dap.toggle_breakpoint()
      end, { desc = 'Toogle [D]ap [B]reakpoint' })

      -- Continue / Start
      vim.keymap.set('n', '<leader>dc', function()
        dap.continue()
      end, { desc = '[D]ap [C]ontinue' })

      -- Step Over
      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, { desc = '[D]ap step [O]ver' })

      -- Step Into
      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, { desc = '[D]ap step [I]nto' })

      -- Step Out
      vim.keymap.set('n', '<leader>dO', function()
        dap.step_out()
      end, { desc = '[D]ap step [O]out' })

      -- Keymap to terminate debugging
      vim.keymap.set('n', '<leader>dq', function()
        require('dap').terminate()
      end, { desc = '[D]ap [Q]uit' })

      -- vim.keymap.set('n', '<leader>dh', function()
      --   require('dap.ui.widgets').hover()
      -- end, { desc = '[D]ap [H]over variable' })
      vim.keymap.set('n', '<leader>dh', function()
        local widgets = require 'dap.ui.widgets'

        widgets.hover()

        local win = vim.api.nvim_get_current_win()
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative == '' then
          return
        end

        local buf = vim.api.nvim_win_get_buf(win)

        local function close_float()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end

        vim.keymap.set('n', 'q', close_float, { buffer = buf, silent = true })
        vim.keymap.set('n', '<Esc>', close_float, { buffer = buf, silent = true })

        local group = vim.api.nvim_create_augroup('DapHoverClose' .. win, { clear = true })

        vim.api.nvim_create_autocmd({ 'WinLeave', 'CursorMoved', 'BufLeave' }, {
          group = group,
          once = true,
          callback = close_float,
        })
      end, { desc = '[D]ap [H]over variable' })

      -- Toggle DAP UI
      vim.keymap.set('n', '<leader>du', function()
        dapui.toggle()
      end, { desc = '[D]ap toogle [U]I' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- -- Install golang specific config
      require('dap-go').setup {
        delve = {},
      }
    end,
  },
}
