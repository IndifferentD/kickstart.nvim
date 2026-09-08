return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  dependencies = { 'saghen/blink.cmp' },

  config = function()
    vim.cmd 'Markview Disable'
    -- Create the toggle only for Markdown buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(ev)
        require('markview.extras.checkboxes').setup()
        vim.keymap.set('n', '<leader>mt', '<cmd>Checkbox toggle<CR>', {
          buffer = ev.buf,
          desc = '[M]arkdown [T]oggle checkbox',
        })
        vim.keymap.set('x', '<leader>mt', ':Checkbox toggle<CR>', {
          buffer = ev.buf,
          desc = '[M]arkdown [T]oggle checkboxes',
        })
        vim.keymap.set('n', '<leader>ms', function()
          vim.cmd 'Markview splitToggle'
        end, {
          buffer = ev.buf,
          desc = '[M]arkview toggle [S]plit preview',
        })
      end,
    })
  end,
}
