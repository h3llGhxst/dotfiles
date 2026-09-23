-- Leader key (must be set before plugins load)
vim.g.mapleader = " "

-- Load plugin manager
require("config.lazy")
require("config.keymaps")
require("config.lsp")

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars:append({ eob = " " })

-- Transparent background
vim.opt.background = "dark"
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
vim.cmd("hi VertSplit ctermbg=NONE guibg=NONE")

-- Cursor
vim.opt.guicursor = "n-c:block,v:block,i-ci-ve:ver25"

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Syntax + filetype
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Treesitter works with Java too
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.cmd("TSBufEnable highlight")
    -- Clear the module cache so jdtls.start_or_attach runs for every java buffer,
    -- not just the first one
    package.loaded["config.java"] = nil
    require("config.java")
  end,
})

-- Diagnostic UI
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show error message" })

-- Center cursor setup
local function center_cursor()
  local height = vim.api.nvim_win_get_height(0)
  vim.opt.scrolloff = math.floor(height / 2)
end

vim.api.nvim_create_autocmd({ "VimResized", "WinEnter" }, {
  callback = center_cursor,
})

center_cursor()

vim.api.nvim_create_user_command("ToggleCenterPin", function()
  vim.opt.scrolloff = vim.opt.scrolloff:get() > 0 and 0 or math.floor(vim.api.nvim_win_get_height(0) / 2)
end, {})

-- Run & compile shortcut
vim.keymap.set("n", "<leader>rr", function()
  local file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  local cmd = ""

  if ext == "c" then
    cmd = string.format("gcc '%s' -o /tmp/a.out && /tmp/a.out", file)
  elseif ext == "cpp" then
    cmd = string.format("g++ '%s' -o /tmp/a.out && /tmp/a.out", file)
  elseif ext == "py" then
    cmd = string.format("python3 '%s'", file)
  elseif ext == "rs" then
    cmd = "cargo run"
  elseif ext == "java" then
    cmd = string.format("javac '%s' && java %s", file, vim.fn.expand("%:t:r"))
  else
    vim.notify("Unsupported filetype: " .. ext)
    return
  end

  vim.cmd("belowright split | terminal " .. cmd)
end, { desc = "Compile and run file" })

