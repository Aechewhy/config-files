-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})
vim.opt.listchars:remove('trail')
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = true

vim.o.mouse = ""
vim.g.snacks_animate = false
