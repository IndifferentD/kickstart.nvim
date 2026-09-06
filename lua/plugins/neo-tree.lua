-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.opt_local.statuscolumn = ''
        end,
      },
    },
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
      },
      commands = {
        live_grep_in_node = function(state)
          local node = state.tree:get_node()
          if not node or not node.path then
            return
          end

          local search_path = node.type == 'directory' and node.path or vim.fs.dirname(node.path)
          if not search_path or search_path == '' then
            return
          end

          require('telescope.builtin').live_grep {
            search_dirs = { search_path },
            prompt_title = 'Live Grep in ' .. vim.fn.fnamemodify(search_path, ':~:.'),
          }
        end,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['g/'] = { 'live_grep_in_node', nowait = false },
        },
      },
    },
  },
}
