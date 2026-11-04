return {
  'javelin-sh/pele.nvim',
  ft = 'markdown',
  cmd = { 'PeleRender', 'PeleToggle' },
  build = 'npm ci',
  dependencies = {
    {
      '3rd/image.nvim',
      build = false,
      opts = {
        backend = 'kitty',
        processor = 'magick_cli',
      },
    },
  },
  opts = {},
}
