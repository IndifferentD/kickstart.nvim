return {
  'sindrets/diffview.nvim',
  config = function()
    require('diffview').setup {
      view = {
        default = { winbar_info = true },
      },
    }

    vim.opt.diffopt:append {
      'algorithm:histogram',
      'indent-heuristic',
    }

    local keymap = vim.keymap.set

    keymap('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git Diff (Diffview)' })
    keymap('n', '<leader>gD', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' })
    keymap('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git File History' })
  end,
}
