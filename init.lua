print("welcome to neovim!")

-----------------------------------------------------------
-- BASIC OPTIONS ------------------------------------------
-----------------------------------------------------------

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true

vim.cmd [[
  highlight Comment gui=italic
  highlight Function gui=italic
  highlight Keyword gui=italic
]]

vim.g.mapleader = " "

-----------------------------------------------------------
-- BOOTSTRAP lazy.nvim ------------------------------------
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- PLUGINS ------------------------------------------------
-----------------------------------------------------------
require("lazy").setup({
  { 'barrett-ruth/live-server.nvim',
    build = 'npm add -g live-server',
    cmd = {'LiveServerStart', 'LiveServerStop'},
    config = true
  },

  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  { "L3MON4D3/LuaSnip" },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
        per_filetype = {
          ["html"] = { enable_close = true }
        }
      })
    end,
  },
})
-----------------------------------------------------------
-- MASON --------------------------------------------------
-----------------------------------------------------------
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "html",
    "cssls",
    "pyright",
    "jdtls",
    "lua_ls",
  },
})

-----------------------------------------------------------
-- COMPLETION ---------------------------------------------
-----------------------------------------------------------
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-----------------------------------------------------------
-- LSP ----------------------------------------------------
-----------------------------------------------------------
vim.lsp.config.ts_ls = { capabilities = capabilities }
vim.lsp.config.html = { capabilities = capabilities }
vim.lsp.config.cssls = { capabilities = capabilities }
vim.lsp.config.pyright = { capabilities = capabilities }
vim.lsp.config.jdtls = { capabilities = capabilities }

vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

-----------------------------------------------------------
-- BASIC KEYMAPS ------------------------------------------
-----------------------------------------------------------
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

