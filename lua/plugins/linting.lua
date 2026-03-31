return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        go = { 'golangcilint' },
        typescript = { 'eslint_d' },
        vue = { 'eslint_d' },
      }

      local golangcilint = lint.linters.golangcilint
      if type(golangcilint) == 'table' then
        golangcilint.ignore_exitcode = true
      end

      local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          local event = args.event

          if filetype == 'go' then
            if event == 'BufWritePost' then
              lint.try_lint(nil, { ignore_errors = true })
            end
            return
          end

          local frontend_filetypes = {
            javascript = true,
            typescript = true,
            vue = true,
          }

          if frontend_filetypes[filetype] then
            lint.try_lint(nil, { ignore_errors = true })
          end
        end,
      })
    end,
  },
}
