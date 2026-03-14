return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        go = { 'golangcilint' },
      }

      local golangcilint = lint.linters.golangcilint
      if type(golangcilint) == 'table' then
        golangcilint.ignore_exitcode = true
      end

      local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function(args)
          if vim.bo[args.buf].filetype == 'go' then
            lint.try_lint(nil, { ignore_errors = true })
          end
        end,
      })
    end,
  },
}
