local function python_package_path()
  local path = vim.api.nvim_buf_get_name(0)
  return path:match('/site%-packages/(.+)$') or path:match('/dist%-packages/(.+)$')
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      always_show_tabline = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
        refresh_time = 16, -- ~60fps
        events = {
          'WinEnter',
          'BufEnter',
          'BufWritePost',
          'SessionLoadPost',
          'FileChangedShellPost',
          'VimResized',
          'Filetype',
          'CursorMoved',
          'CursorMovedI',
          'ModeChanged',
        },
      },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {
        {
          function()
            if python_package_path() then
              return 'Python packages'
            end
            return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
          end,
          icon = '',
        },
        {
          'filename',
          fmt = function(filename)
            local package_path = python_package_path()
            local parent = package_path and package_path:match('^(.+/)[^/]+$')
            return parent and (parent:gsub('%%', '%%%%') .. filename) or filename
          end,
          symbols = {
            modified = ' [+]',
            readonly = ' [RO]',
            unnamed = '[No Name]',
            newfile = '[New]',
          },
        },
      },
      lualine_c = {
        {
          function()
            local ok, navic = pcall(require, 'nvim-navic')
            if not ok or not navic.is_available() then
              return ''
            end
            return navic.get_location()
          end,
          cond = function()
            local ok, navic = pcall(require, 'nvim-navic')
            return ok and navic.is_available()
          end,
          color = { fg = '#7aa2f7' },
        },
      },
      lualine_x = {
        {
          'branch',
          icon = '',
        },
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          sections = { 'error', 'warn', 'info', 'hint' },
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
          },
          colored = true,
          update_in_insert = false,
          always_visible = false,
        },
        {
          function()
            local buf_clients = vim.lsp.get_clients { bufnr = 0 }
            if #buf_clients == 0 then
              return 'No LSP'
            end
            return buf_clients[1].name
          end,
          icon = '',
        },
        {
          'filetype',
          icon_only = false,
        },
        'encoding',
        'fileformat',
      },
      lualine_y = { 'location' },
      lualine_z = { 'progress' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
}
