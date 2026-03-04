return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional (Neogit can use it for diffs). Keep even if you later remove Diffview plugin file.
    'nvim-telescope/telescope.nvim', -- optional (for pickers)
  },
  cmd = { 'Neogit' },
  keys = {
    { '<leader>ng', '<cmd>Neogit<cr>', desc = 'Neogit: Open' },
    -- Direct to commit popup is nice when you're staging a lot
    { '<leader>nc', '<cmd>Neogit commit<cr>', desc = 'Neogit: Commit' },
  },
  opts = {
    -- This makes Neogit behave closer to “single status UI”
    kind = 'tab', -- "split" or "tab"
    disable_signs = false,
    disable_hint = false,

    -- Neogit has its own integrated staging UI (hunks/lines) inside status buffer.
    -- It can also use external diffs; keeping defaults is fine.

    integrations = {
      diffview = true, -- if installed; can be false if you remove diffview later
    },
  },
}
