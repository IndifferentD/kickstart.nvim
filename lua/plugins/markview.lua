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
