-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local function copy_file_names(nodes)
  local names = {}
  for _, node in ipairs(nodes) do
    if node.type == 'file' then
      names[#names + 1] = node.name
    end
  end

  if #names == 0 then
    vim.notify('No files selected', vim.log.levels.INFO)
    return
  end

  table.sort(names)
  vim.fn.setreg('+', table.concat(names, '\n'))
  vim.notify(('Copied %d file name(s)'):format(#names), vim.log.levels.INFO)
end

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
        copy_file_names = function(state)
          copy_file_names { state.tree:get_node() }
        end,
        copy_file_names_visual = function(_, selected_nodes)
          copy_file_names(selected_nodes)
        end,
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
          ['Y'] = { 'copy_file_names', desc = 'Copy selected file names' },
        },
      },
    },
  },
}
