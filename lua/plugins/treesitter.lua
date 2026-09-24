return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    opts = {
      parsers = {
        'bash',
        'c',
        'css',
        'diff',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'sql',
        'typescript',
        'vue',
        'vim',
        'vimdoc',
        'nix',
      },
    },
    config = function(_, opts)
      local treesitter = require 'nvim-treesitter'
      treesitter.setup {}
      treesitter.install(opts.parsers)
    end,
  },
}
