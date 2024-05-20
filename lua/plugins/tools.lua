return {
	-- Floating terminal
	-- {
	-- 	'akinsho/toggleterm.nvim',
	-- 	keys = { [[<c-\>]] },
	-- 	opts = {
	-- 		open_mapping = [[<c-\>]],
	-- 		direction = 'float',
	-- 		close_on_exit = true,
	-- 	}
	-- },
	-- -- Auto create on save
	-- 'jghauser/mkdir.nvim',
	{ -- Markdown live preview
		'iamcco/markdown-preview.nvim',
		-- build = 'cd app && yarn install',
		build = require('nixCatsUtils.lazyCat').lazyAdd('cd app && yarn install'),
		cmd = 'MarkdownPreview',
		ft = { 'markdown' },
		config = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end
	},
	{ -- Auto detect tabstop and shiftwidth
		'tpope/vim-sleuth',
		event = "BufReadPost",
	},
	{
		-- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		lazy = true,
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',

			-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = require('nixCatsUtils.lazyCat').lazyAdd('cmake'),
				cond = require('nixCatsUtils.lazyCat').lazyAdd(function()
					return vim.fn.executable 'cmake' == 1
				end),
			},
			{
				'natecraddock/telescope-zf-native.nvim',
			},
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
				winblend = 30,
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				project = {
					base_dirs = {
						{ "~/projects" },
						{ "~/personal_projects" },
						{ "~/.config" }
					},
					on_project_selected = function(bufnr)
						require("telescope._extensions.project.actions")
						    .change_working_directory(bufnr)
					end
				}
			},
		},
		keys = function(_, keys)
			local telescope = require('telescope.builtin')
			local mappings = {
				{
					'<leader><leader>',
					function()
						telescope.buffers()
					end,
					desc = '[ ] Search buffers'
				},
				{
					'<leader>/',
					function()
						telescope.current_buffer_fuzzy_find(require('telescope.themes')
							.get_dropdown {
								winblend = 10,
								previewer = false,
							})
					end
					,
					desc = '[/] Fuzzily search in current buffer]',
				},
				{ '<leader>sf', telescope.find_files, desc = '[S]earch [F]iles' },
				{ '<leader>sh', telescope.help_tags,  desc = '[S]earch [H]elp' },
				-- {
				-- 	'<leader>sw',
				-- 	require('telescope').extensions.git_worktree.git_worktrees,
				-- 	desc = "[S]earch Git [W]orktrees",
				-- },
				{
					'<leader>sg',
					telescope.live_grep,
					desc = '[S]earch by [G]rep',
				},
				{
					'<leader>sk',
					telescope.keymaps,
					desc = '[S]earch [K]eymaps',
				},
				{
					'<leader>ss',
					telescope.resume,
					desc = '[S]earch Resume'
				}
			}
			return vim.list_extend(mappings, keys)
		end,
		config = function(_, opts)
			local telescope = require 'telescope'
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			telescope.setup(opts)

			-- Enable telescope fzf native, if installed
			telescope.load_extension('fzf')
			telescope.load_extension('zf-native')

			-- -- Enable git-worktree integration
			-- telescope.load_extension('git_worktree')

			telescope.load_extension('hoogle')

			-- telescope.load_extension('project')
		end
	},
	{
		-- Kitty window integration
		'mrjones2014/smart-splits.nvim',
		-- build = './kitty/install-kittens.bash',
		build = require('nixCatsUtils.lazyCat').lazyAdd('./kitty/install-kittens.bash'),
		opts = {
			ignored_filetypes = {
				'neo-tree',
			},
			ignored_buftype = {
				'nofile'
			},
			at_edge = 'stop',
		},
		keys = {
			{
				'<M-h>',
				function() require("smart-splits").resize_left(vim.v.count1) end,
				desc = 'Resize left',
			},
			{
				'<M-l>',
				function() require("smart-splits").resize_right(vim.v.count1) end,
				desc = 'Resize right',
			},
			{
				'<M-j>',
				function() require("smart-splits").resize_down(vim.v.count1) end,
				desc = 'Resize up',
			},
			{
				'<M-k>',
				function() require("smart-splits").resize_up(vim.v.count1) end,
				desc = 'Resize down',
			},
			{
				'<C-h>',
				function() require("smart-splits").move_cursor_left() end,
				desc = 'Move cursor left',
			},
			{
				'<C-l>',
				function() require("smart-splits").move_cursor_right() end,
				desc = 'Move cursor right',
			},
			{
				'<C-k>',
				function() require("smart-splits").move_cursor_up() end,
				desc = 'Move cursor up',
			},
			{
				'<C-j>',
				function() require("smart-splits").move_cursor_down() end,
				desc = 'Move cursor down',
			},
		}
	},
	{
		"coffebar/neovim-project",
		-- event = "VeryLazy",
		lazy = false,
		opts = {
			last_session_on_startup = false,
			projects = { -- define project roots
				"~/projects/*",
				"~/personal_projects/*",
				"~/.config/*",
			},
		},
		init = function()
			-- enable saving the state of plugins in the session
			vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		end,
		keys = {
			{
				'<leader>p',
				function()
					require("telescope").extensions["neovim-project"].history()
				end,
				desc = '[P]roject Manager',
			},
			{
				'<leader>P',
				function()
					require("telescope").extensions["neovim-project"].discover()
				end,
				desc = '[P]roject Manager',
			}
		},
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "Shatur/neovim-session-manager" },
		},
	},
	{
		'mikesmithgh/kitty-scrollback.nvim',
		lazy = true,
		event = { 'User KittyScrollbackLaunch' },
		cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
		-- version = '*', -- latest stable version, may have breaking changes if major version changed
		-- version = '^1.0.0', -- pin major version, include fixes and features that do not have breaking changes
		opts = {}
	},
	{
		'kristijanhusak/vim-dadbod-ui',
		dependencies = {
			{ 'tpope/vim-dadbod', lazy = true },
			{
				'kristijanhusak/vim-dadbod-completion',
				ft = { 'sql', 'mysql', 'plsql' },
				lazy = true,
				config = function()
					require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
						sources = {
							{ name = "vim-dadbod-completion" },
						}
					})
				end
			},
		},
		cmd = {
			'DBUI',
			'DBUIToggle',
			'DBUIAddConnection',
			'DBUIFindBuffer',
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		'TobinPalmer/pastify.nvim',
		cmd = { 'Pastify' },
		opts = {}
	}
}
