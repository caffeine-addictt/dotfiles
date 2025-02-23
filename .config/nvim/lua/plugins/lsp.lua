return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "c", "lua", "rust", "go", "proto" },
      tailwind = {},
      python = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
      },
    },
  },
}
