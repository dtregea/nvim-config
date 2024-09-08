vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Solargraph setup with ruby 2.7 and rails support
-- Install ruby 2.7.1 with rbenv
-- Install solargraph with `gem install solargraph`, no sudo
-- Similarly, install solargraph-rails, no sudo
-- Solargraph: 0.50.0, Solargraph Rails: 1.10.0
-- Add a .solargraph.yml file in the root of your projects, run "solargraph config ." in project root
-- Specify solargraph-rails in the plugins section of solargraph.yml
-- Run 'yard gems'
require("lspconfig").solargraph.setup {
  cmd = { os.getenv "HOME" .. "/.rbenv/shims/solargraph", "stdio" },
  filetypes = { "ruby" },
  root_dir = require("lspconfig/util").root_pattern("Gemfile", ".git"),
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
}
