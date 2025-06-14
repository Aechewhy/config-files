-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = {noremap = true, silent = true}
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "<leader><leader>q", ":q<Return>", {desc = "Quit Neovim"})
keymap.set("n", "<leader><leader>Q", ":q!<Return>", {desc = "Force Quit"} )
keymap.set("n", "<leader><leader>w", ":w<Return>", {desc = "Save file"})
keymap.set("n", "<leader><leader>x", ":x<Return>",{desc = "Save and quit"})
keymap.set("n", "<leader><leader>X", ":wqa<Return>", {desc = "Save and quit all files"})


vim.keymap.del("n", "<leader><leader>") --Disable open telescope

--------------------------------------------------------------------------------------------------------------
-----Hop.nvim
--------------------------------------------------------------------------------------------------------------
keymap.set({"n", "v"}, "<leader>w", "<Cmd>HopWord<CR>", {desc = "Hop to word"})
keymap.set({"n", "v"}, "<leader>l", "<Cmd>HopLine<CR>", {desc = "Hop to line"})
keymap.set({"n", "v"}, "f", "<Cmd>HopAnywhere<CR>", {desc = "Hop to anywhere"})
keymap.set({"n", "v"}, "F", "<Cmd>HopeChar1<CR>", {desc = "Hop to one character"})
