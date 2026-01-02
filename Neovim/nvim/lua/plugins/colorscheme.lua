
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000, -- ensure it loads before other UI plugins
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
    end,
  },
  {
    'maxmx03/fluoromachine.nvim',
    name = "fluoromachine",
    lazy = false,
    priority = 1000,
    config = function ()
      local fm = require 'fluoromachine'
      fm.setup {
        theme = 'retrowave',
        brightness = 0.05,
        glow = false,
        transparent = true,
        styles = {
          comments = {},
          functions = {},
          variables = {},
          numbers = {},
          constants = {},
          parameters = {},
          keywords = {},
          types = {},
        },
        colors = {},
        overrides = {},
        plugins = {
          bufferline = true,
          cmp = true,
          dashboard = true,
          editor = true,
          gitsign = true,
          hop = true,
          ibl = true,
          illuminate = true,
          lazy = true,
          minicursor = true,
          ministarter = true,
          minitabline = true,
          ministatusline = true,
          navic = true,
          neogit = true,
          neotree = true,
          yazi = true,
          snacks = true,
          noice = true,
          notify = true,
          lspconfig = true,
          syntax = true,
          telescope = true,
          treesitter = true,
          tree = true,
          wk = true,
        },
      }
    end
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    -- ← here’s your opts for tokyonight
    opts = {
      style           = "moon",
      transparent     = true,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        sidebars  = "dark",
        floats    = "dark",
      },
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold }
    },
  }
}
