return {
	{
		-- Test runner
		"nvim-neotest/neotest",
		lazy = true,
		-- event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- "antoinemadec/FixCursorHold.nvim",
			"rouge8/neotest-rust",
			"mrcjkb/neotest-haskell"
		},
		opts = function()
			return {
				adapters = {
					require("neotest-rust") {},
					require("neotest-haskell") {}
				}
			}
		end
	},
	{
		-- Debugging
		"mfussenegger/nvim-dap",
		lazy = true,
		-- event = "LspAttach",
		enabled = vim.fn.has "win32" == 0,
		dependencies = {
			-- {
			-- 	"jay-babu/mason-nvim-dap.nvim",
			-- 	cmd = {
			-- 		"DapInstall",
			-- 		"DapUninstall"
			-- 	},
			-- 	opts = { automatic_setup = true
			-- 	},
			-- },
			{
				"rcarriga/nvim-dap-ui",
				dependencies = "nvim-neotest/nvim-nio",
				opts = {
					floating = { border = "rounded" }
				},
				config = function(_, opts)
					local dap, dapui = require "dap", require "dapui"
					dap.listeners.after.event_initialized[
					"dapui_config"
					] = function() dapui.open() end
					dap.listeners.before.event_terminated[
					"dapui_config"
					] = function() dapui.close() end
					dap.listeners.before.event_exited[
					"dapui_config"
					] = function() dapui.close() end
					dapui.setup(opts)
				end
			},
			{
				'theHamsta/nvim-dap-virtual-text',
				--- @type nvim_dap_virtual_text_options
				opts = {
					commented = true,
					only_first_definition = false,
					all_references = true,
				}
			}
		},
		config = function()
			local dap = require("dap")
			dap.adapters.lldb = {
				type = 'executable',
				command = '/usr/bin/lldb-vscode',
				name = 'lldb'
			}
			dap.configurations.lua = {
				{
					type = 'nlua',
					request = 'attach',
					name = "Attach to running NeoVim instance"
				}
			}
		end
	},
	-- {
	-- 	-- NeoVim DAP adapter
	-- 	'jbyuki/one-small-step-for-vimkind',
	-- 	ft = 'lua',
	-- 	event = "LspAttach",
	-- }
}
