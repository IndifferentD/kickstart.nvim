return {
  'j-hui/fidget.nvim',
  opts = {
    progress = {
      lsp = {
        log_handler = true,
      },
      display = {
        render_limit = 16,
        done_ttl = 3,
        skip_history = false,
      },
    },
  },
}
