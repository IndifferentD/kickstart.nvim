return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  opts = {
    explorer = { view_mode = 'tree' },
  },
  keys = {
    { '<leader>gC', '<cmd>CodeDiff<cr>', desc = 'Git Diff (CodeDiff)' },
  },
}
