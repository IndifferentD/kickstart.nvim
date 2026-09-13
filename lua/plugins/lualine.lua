local function library_location()
  local path = vim.api.nvim_buf_get_name(0)
  local module_path = path:match '/pkg/mod/(.+@v%d[^/]*/.+)$'
  if module_path then
    return 'Go modules', module_path
  end

  local go_stdlib_path = path:match '/go/src/(.+)$'
  if go_stdlib_path then
    return 'Go stdlib', go_stdlib_path
  end

  local package_path = path:match '/site%-packages/(.+)$' or path:match '/dist%-packages/(.+)$'
  if package_path then
    return 'Python packages', package_path
  end

  local version, library_path = path:match '/lib/python(%d+%.%d+)/(.+)$'
  if version then
    return 'Python ' .. version .. ' stdlib', library_path
  end
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nickkadutskyi/jb.nvim' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
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
      lualine_b = {},
      lualine_c = {
        {
          'nav_bar',
          padding = { left = 1, right = 0 },
          cond = function()
            return library_location() == nil
          end,
        },
        {
          function()
            local label = library_location()
            if label then
              return label
            end
            return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
          end,
          icon = '',
          cond = function()
            return library_location() ~= nil
          end,
        },
        { 'filetype', icon_only = true, padding = { left = 0, right = 0 } },
        {
          'filename',
          padding = { left = 0, right = 1 },
          fmt = function(filename)
            local _, library_path = library_location()
            local parent = library_path and library_path:match '^(.+/)[^/]+$'
            return parent and (parent:gsub('%%', '%%%%') .. filename) or filename
          end,
          symbols = {
            modified = ' [+]',
            readonly = ' [RO]',
            unnamed = '[No Name]',
            newfile = '[New]',
          },
        },
        {
          function()
            local ok, navic = pcall(require, 'nvim-navic')
            if not ok or not navic.is_available() then
              return ''
            end
            return '› ' .. navic.get_location()
          end,
          cond = function()
            local ok, navic = pcall(require, 'nvim-navic')
            return ok and navic.is_available()
          end,
          padding = { left = 0, right = 1 },
        },
      },
      lualine_x = {
        {
          'branch',
          icon = '',
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
