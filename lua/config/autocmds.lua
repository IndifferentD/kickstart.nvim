vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable Treesitter highlighting and indentation',
  group = vim.api.nvim_create_augroup('config-treesitter', { clear = true }),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match)
    if not lang then
      return
    end

    local function start()
      if not vim.api.nvim_buf_is_valid(event.buf) or vim.bo[event.buf].filetype ~= event.match then
        return
      end
      vim.treesitter.start(event.buf, lang)
      if event.match ~= 'ruby' and vim.treesitter.query.get(lang, 'indents') then
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local has_highlights = #vim.treesitter.query.get_files(lang, 'highlights') > 0
    if has_highlights and vim.treesitter.language.add(lang) then
      start()
    elseif require('nvim-treesitter.parsers')[lang] then
      require('nvim-treesitter').install({ lang }):await(function(err, installed)
        if not err and installed then
          vim.schedule(start)
        end
      end)
    end
  end,
})
