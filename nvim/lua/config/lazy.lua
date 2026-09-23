
-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- 🌙 Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        styles = {
          functions = { italic = true },
          keywords = { italic = false },
        },
        on_highlights = function(hl, c)
          hl["@variable"]           = { fg = c.fg }
          hl["@variable.member"]    = { fg = c.cyan }
          hl["@variable.parameter"] = { fg = c.orange }
          hl["@type"]               = { fg = c.yellow }
          hl["@type.builtin"]       = { fg = c.yellow, italic = true }
          hl["@function.builtin"]   = { fg = c.cyan, italic = true }
          hl["@constant"]           = { fg = c.orange }
          hl["@constant.builtin"]   = { fg = c.orange, bold = true }
        end,
      })
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
    {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
},
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls", "lua_ls", "jdtls", "clangd", "rust_analyzer" },
    })
  end,
},


  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "go", "java", "python", "bash", "json", "html", "css"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true })
    end,
  },

  -- LSP
  { "neovim/nvim-lspconfig" },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Supermaven (ghost text only)
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-CR>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        disable_inline_completion = false,
        disable_keymaps = false,
      })
      vim.keymap.set("n", "<leader>sm", "<cmd>SupermavenToggle<CR>", { desc = "Toggle Supermaven" })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- UI & extras
  { "nvim-lualine/lualine.nvim", config = function() require("lualine").setup() end },
  { "nvim-tree/nvim-tree.lua", config = function() require("nvim-tree").setup() end },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
  { "folke/which-key.nvim", config = function() require("which-key").setup() end },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }
      dashboard.section.footer.val = "🔥 Neovim loaded. Let’s code something legendary."
      alpha.setup(dashboard.config)
    end,
  },

  -- Fun
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },

})

