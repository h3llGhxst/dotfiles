local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply capabilities to all servers
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- lua_ls needs extra settings to recognise the vim global
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        pyflakes    = { enabled = false },
        mccabe      = { enabled = false },
      },
    },
  },
})

vim.lsp.config("asm_lsp", {
  filetypes = { "asm", "s", "S" },
})

vim.lsp.enable({ "pylsp", "gopls", "lua_ls", "clangd", "rust_analyzer", "asm_lsp" })
