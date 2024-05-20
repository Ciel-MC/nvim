require('nixCatsUtils').setup { non_nix_value = true }

-- [[ Setting options ]]
-- See `:help vim.o`

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- transparent background
vim.o.background = 'dark'
vim.g.neovide_transparency = 0.6
vim.g.neovide_input_macos_alt_is_meta = true
-- vim.o.guifont = 'FiraCode Nerd Font:h18'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
-- Make line numbers relative
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Set Neovide font to Fira Code
vim.o.guifont = 'FiraCode Nerd Font:h18'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Make autocomplete popups transparent
vim.o.pumblend = 30
vim.o.winblend = 20

-- Scroll 5 lines from the cursors
vim.o.scrolloff = 5

-- Fold regions using treesitter
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', function()
    return vim.v.count == 0 and 'gk' or 'k'
end, { expr = true, silent = true })
vim.keymap.set('n', 'j', function()
    return vim.v.count == 0 and 'gj' or 'j'
end, { expr = true, silent = true })

-- Switch between buffers
vim.keymap.set('n', 'gt', vim.cmd.tabn, { silent = true })
vim.keymap.set('n', 'gT', vim.cmd.tabp, { silent = true })

-- Keep selected text after indenting in visual mode
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- Insert a new line without going into insert mode
vim.keymap.set('n', '<CR>', 'o<Esc>', { silent = true })

-- Scrolling also center the cursor
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })

-- Go to line start and end using H and L
vim.keymap.set({ 'n', 'v', 'o' }, 'H', '^', { silent = true })
vim.keymap.set({ 'n', 'v', 'o' }, 'L', '$', { silent = true })

-- Remove Tab jumpping
-- vim.keymap.set('i', '<Tab>', '<Nop>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
    local allPlugins = require("nixCats").pawsible.allPlugins
    -- it is called pluginList because we only need to pass in the names
    pluginList = require('nixCatsUtils.lazyCat').mergePluginTables(allPlugins.start, allPlugins.opt)
    -- it wasnt detecting these because the names are slightly different.
    -- when that happens, add them to the list, then also specify name in the lazySpec
    pluginList[ [[Comment.nvim]] ] = ""
    pluginList[ [[LuaSnip]] ] = ""
    nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end

require('nixCatsUtils.lazyCat').setup(pluginList, nixLazyPath, 'plugins')
vim.cmd [[colorscheme onedark]]
-- vim.cmd [[colorscheme molokai]]
-- vim.cmd [[colorscheme nightfox]]
