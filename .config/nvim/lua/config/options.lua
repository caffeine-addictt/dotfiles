-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.winbar = "%=%m %f"
vim.g.autoformat = true
vim.lsp.set_log_level("WARN")

local opt = vim.opt

opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.autoindent = true

vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2
