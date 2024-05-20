return {
	{
		'mrcjkb/haskell-tools.nvim',
		-- version = '^3', -- Recommended
		lazy = false;
		ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
		keys = {
			{
				'<space>ca',
				vim.lsp.codelens.run,
				desc = 'Evaluate codelens'
			},
			{
				'<space>ch',
				function()
					require('haskell-tools').lsp.buf_eval_all()
				end,
			}
		},
		config = function()
			vim.g.haskell_tools = {
				hls = {
					on_attach = require 'plugins.utils.utils'._on_attach
				}
			}
		end
	},
	'luc-tielen/telescope_hoogle',
	'mrcjkb/haskell-snippets.nvim',
	-- {
	-- 	'Vigemus/iron.nvim',
	-- 	lazy = true,
	-- 	main = 'iron.core',
	-- 	opts = {
	-- 		config = {
	-- 			repl_definition = {
	-- 				haskell = {
	-- 					command = function(meta)
	-- 						local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
	-- 						-- call `require` in case iron is set up before haskell-tools
	-- 						return require('haskell-tools').repl.mk_repl_cmd(file)
	-- 					end,
	-- 				},
	-- 			},
	-- 		},
	-- 	}
	-- }
}
