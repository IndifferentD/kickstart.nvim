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
      local map = vim.keymap.set
      dap_python.setup 'uv'
      -- dap_python.test_runner = "pytest"
      dapui.setup {
        layouts = {
          {
            position = 'left',
            size = 55, -- ширина левой панели
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
      map('n', '<leader>db', function()
        dap.toggle_breakpoint()
      end, { desc = 'Toogle [D]ap [B]reakpoint' })

      -- Continue / Start
      map('n', '<leader>dc', function()
        dap.continue()
      end, { desc = '[D]ap [C]ontinue' })

      -- Step Over
      map('n', '<leader>do', function()
        dap.step_over()
      end, { desc = '[D]ap step [O]ver' })

      -- Step Into
      map('n', '<leader>di', function()
        dap.step_into()
      end, { desc = '[D]ap step [I]nto' })

      -- Step Out
      map('n', '<leader>dO', function()
        dap.step_out()
      end, { desc = '[D]ap step [O]out' })

      -- Keymap to terminate debugging
      map('n', '<leader>dq', function()
        require('dap').terminate()
      end, { desc = '[D]ap [Q]uit' })

      -- vim.keymap.set('n', '<leader>dh', function()
      --   require('dap.ui.widgets').hover()
      -- end, { desc = '[D]ap [H]over variable' })
      map('n', '<leader>dh', function()
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

        map('n', 'q', close_float, { buffer = buf, silent = true })
        map('n', '<Esc>', close_float, { buffer = buf, silent = true })

        local group = vim.api.nvim_create_augroup('DapHoverClose' .. win, { clear = true })

        vim.api.nvim_create_autocmd({ 'WinLeave', 'CursorMoved', 'BufLeave' }, {
          group = group,
          once = true,
          callback = close_float,
        })
      end, { desc = '[D]ap [H]over variable' })

      -- Toggle DAP UI
      map('n', '<leader>du', function()
        dapui.toggle()
      end, { desc = '[D]ap toogle [U]I' })

      -- JetBrains-style debug flow on function keys.
      map('n', '<F7>', function()
        dap.step_into()
      end, { desc = 'Debug: Step Into' })
      map('n', '<F8>', function()
        dap.step_over()
      end, { desc = 'Debug: Step Over' })
      map('n', '<S-F8>', function()
        dap.step_out()
      end, { desc = 'Debug: Step Out' })
      map('n', '<F9>', function()
        dap.continue()
      end, { desc = 'Debug: Resume' })
      map('n', '<S-F9>', function()
        dap.continue()
      end, { desc = 'Debug: Start / Continue' })
      map('n', '<C-F8>', function()
        dap.toggle_breakpoint()
      end, { desc = 'Debug: Toggle Breakpoint' })
      map('n', '<A-F8>', function()
        local widgets = require 'dap.ui.widgets'
        widgets.hover()
      end, { desc = 'Debug: Inspect Value' })

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
