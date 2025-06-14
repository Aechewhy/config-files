local builtin = require('telescope.builtin')
local keymap = vim.keymap
return {
  "nvim-telescope/telescope.nvim",  -- This is the plugin you're configuring
  dependencies = { 'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function ()
    keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end

  -- opts = {                          -- 'opts' lets you override or extend default options
  --   defaults = {                    -- General/default settings for all Telescope pickers
  --     previewer = true,             -- Enable previewer globally (for all pickers unless overridden)
  --     layout_strategy = "horizontal",
  --   },
  --   pickers = {                     -- Specific settings for individual pickers (features in Telescope)
  --     find_files = {
  --       previewer = true,           -- Enable previewer for the :Telescope find_files picker
  --     },
  --     buffers = {
  --       previewer = true,           -- Enable previewer for the :Telescope buffers picker
  --     },
  --   },
  -- },
}
