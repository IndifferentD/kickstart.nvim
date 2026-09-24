return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'SmiteshP/nvim-navic',
        dependencies = { 'nickkadutskyi/jb.nvim' },
        opts = function()
          local icons = vim.tbl_map(function(icon)
            return icon ~= '' and (icon .. ' ') or ''
          end, require('jb.icons').kind)
          return {
            highlight = true,
            separator = ' › ',
            depth_limit = 5,
            icons = icons,
            lsp = { auto_attach = true, preference = { 'vue_ls', 'vtsls' } },
          }
        end,
      },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      local function buffer_augroup_name(prefix, bufnr)
        return string.format('%s-%d', prefix, bufnr)
      end

      ---@param client vim.lsp.Client
      ---@param method vim.lsp.protocol.Method.ClientToServer
      ---@param bufnr? integer
      ---@return boolean
      local function client_supports_method(client, method, bufnr)
        return client:supports_method(method, bufnr)
      end

      local function has_highlight_client(bufnr)
        for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
          if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
            return true
          end
        end

        return false
      end

      local function setup_document_highlight(client, bufnr)
        if not client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
          return
        end

        local highlight_group = vim.api.nvim_create_augroup(buffer_augroup_name('kickstart-lsp-highlight', bufnr), { clear = true })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup(buffer_augroup_name('kickstart-lsp-detach', bufnr), { clear = true }),
          buffer = bufnr,
          callback = function(event)
            vim.schedule(function()
              if has_highlight_client(event.buf) then
                return
              end

              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = buffer_augroup_name('kickstart-lsp-highlight', event.buf),
                buffer = event.buf,
              }
            end)
          end,
        })
      end

      local function setup_codelens(client, bufnr, map)
        if not client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens, bufnr) then
          return
        end

        map('<leader>cl', vim.lsp.codelens.run, '[C]ode [L]ens')
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
      end

      local function setup_inlay_hints(client, bufnr, map)
        if not client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
          return
        end

        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
        end, '[T]oggle Inlay [H]ints')
      end

      vim.lsp.inlay_hint.enable(true)

      local function configure_client_capabilities(client)
        if client.name == 'sqls' then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end

      -- Neovim 0.11 ships global LSP defaults like `gra`, `grr`, `grn`, etc.
      -- They make `gr` behave like a prefix, which conflicts with this config's
      -- direct `gr` mapping for references.
      for _, keys in ipairs { 'gra', 'gri', 'grn', 'grr', 'grt' } do
        pcall(vim.keymap.del, 'n', keys)
      end

      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gy', require('telescope.builtin').lsp_type_definitions, 'Goto T[y]pe Definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          configure_client_capabilities(client)
          setup_document_highlight(client, event.buf)
          setup_codelens(client, event.buf, map)
          setup_inlay_hints(client, event.buf, map)
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        cssls = {},
        docker_language_server = {},
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              vulncheck = 'Imports',
              codelenses = {
                run_govulncheck = true,
                upgrade_dependency = true,
                tidy = true,
                vendor = true,
              },
              analyses = {
                unusedparams = true,
                fieldalignment = true,
                inferTypeArgs = true,
              },
            },
          },
        },
        -- nushell = {
        --   cmd = { 'nu', '--lsp' },
        --   root_dir = function(bufnr, on_dir)
        --     local filename = vim.api.nvim_buf_get_name(bufnr)
        --     on_dir(vim.fs.root(filename, { '.git' }) or vim.fs.dirname(filename))
        --   end,
        -- },
        basedpyright = {
          cmd = { 'basedpyright-langserver', '--stdio' },
          filetypes = { 'python' },
          -- settings = {
          --   -- you can customize these
          --   basedpyright = {
          --     analysis = {
          --       autoSearchPaths = true,
          --       useLibraryCodeForTypes = true,
          --       typeCheckingMode = 'basic',
          --     },
          --   },
          -- },
        },
        -- sqlls = {
        --   -- optional: you can override defaults, but you usually don't need to.
        --   cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
        --   filetypes = { 'sql', 'mysql' },
        -- },
        sqls = {
          filetypes = { 'sql', 'mysql' },
        },
        vtsls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
          },
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  vue_plugin,
                },
              },
            },
          },
        },
        vue_ls = {},

        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true, paramName = 'All' },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        ruff = {
          cmd = { 'ruff', 'server' },
          filetypes = { 'python' },
        },
        nil_ls = {},
      }
      local mason_excluded_servers = {
        nushell = true,
        nixd = true,
      }
      local mason_servers = vim.tbl_filter(function(server_name)
        return not mason_excluded_servers[server_name]
      end, vim.tbl_keys(servers))

      require('mason-lspconfig').setup {
        ensure_installed = mason_servers,
        automatic_enable = false,
      }
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua', -- Used to format Lua code
          'delve', -- Used by nvim-dap-go
          'golangci-lint', -- Used by nvim-lint for Go diagnostics
          'hadolint', -- Used by nvim-lint for Dockerfile diagnostics
          'prettierd', -- Used by conform for frontend formatting
          'eslint_d', -- Used by nvim-lint for frontend diagnostics
        },
      }

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
