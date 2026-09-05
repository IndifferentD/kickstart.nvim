vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set({ 'n', 'x' }, '<leader>yl', function()
  if vim.bo.buftype ~= '' or vim.api.nvim_buf_get_name(0) == '' then
    vim.notify('Current buffer is not a named file', vim.log.levels.WARN)
    return
  end

  local location = vim.fn.expand '%:p'
  local current_line = vim.fn.line '.'
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\022' then
    local anchor_line = vim.fn.line 'v'
    location = string.format('%s:%d-%d', location, math.min(anchor_line, current_line), math.max(anchor_line, current_line))
  else
    location = string.format('%s:%d', location, current_line)
  end
  vim.fn.setreg('+', location, 'v')
end, { desc = '[Y]ank [L]ocation' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Previous [D]iagnostic' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist, { desc = 'Open workspace diagnostic quickfix list' })
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float { focusable = true }
end, { desc = 'Expand an Error into a float' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next [Q]uickfix item' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous [Q]uickfix item' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
