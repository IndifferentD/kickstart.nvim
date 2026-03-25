return {
  'okuuva/auto-save.nvim',
  event = { 'InsertLeave', 'TextChanged' },
  opts = {
    enabled = true,

    trigger_events = {
      immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' },
      defer_save = { 'InsertLeave', 'TextChanged' },
      cancel_deferred_save = { 'InsertEnter' },
    },

    debounce_delay = 2000,

    condition = function(buf)
      local fn = vim.fn
      return fn.getbufvar(buf, '&modifiable') == 1 and fn.getbufvar(buf, '&readonly') == 0 and fn.expand '%' ~= ''
    end,
  },
}
