return {
  {
    "Exafunction/codeium.nvim",
    opts = {
      enable_line_highlights = false,
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "Exafunction/codeium.nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "codeium" },
        providers = {
          codeium = {
            kind = "Codeium",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
