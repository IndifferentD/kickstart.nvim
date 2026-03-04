return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G', 'Gvdiffsplit', 'Gdiffsplit', 'Gedit', 'Gread', 'Gwrite', 'Gblame' },
  keys = {
    -- Main entry
    { '<leader>gg', '<cmd>Git<cr>', desc = 'Fugitive: Git status' },

    -- Diff against index / staging workflow
    { '<leader>gvd', '<cmd>Gvdiffsplit<cr>', desc = 'Fugitive: Vertical diff (index <-> working tree)' },
    { '<leader>gds', '<cmd>Gdiffsplit<cr>', desc = 'Fugitive: Diff split (index <-> working tree)' },

    -- Quick actions
    { '<leader>gbl', '<cmd>Gblame<cr>', desc = 'Fugitive: Blame' },
    -- { "<leader>gpl", "<cmd>Git pull<cr>", desc = "Fugitive: Pull" },
    -- { "<leader>gps", "<cmd>Git push<cr>", desc = "Fugitive: Push" },
  },
  config = function()
    -- Optional: make diff experience nicer for staging with :Gvdiffsplit
    vim.opt.diffopt:append { 'algorithm:histogram', 'indent-heuristic', 'filler' }
  end,
}
