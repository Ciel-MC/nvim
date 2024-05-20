return {
	-- require('plugins.ai-completion.codeium'),

	-- require('plugins.ai-completion.copilot'),

	-- {
	--     "jackMort/ChatGPT.nvim",
	--     event = "VeryLazy",
	--     name = "chatgpt",
	--     dependencies = {
	--         "MunifTanjim/nui.nvim",
	--         "nvim-lua/plenary.nvim",
	--         "nvim-telescope/telescope.nvim"
	--     },
	--     opts = {
	--         api_key_cmd = 'op read "op://private/NeoVim OpenAI/api key"',
	--     }
	-- },

	-- AI assistant using OpenAI
	{
		"Bryley/neoai.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		cmd = {
			"NeoAI",
			"NeoAIOpen",
			"NeoAIClose",
			"NeoAIToggle",
			"NeoAIContext",
			"NeoAIContextOpen",
			"NeoAIContextClose",
			"NeoAIInject",
			"NeoAIInjectCode",
			"NeoAIInjectContext",
			"NeoAIInjectContextCode",
		},
		keys = {
			{ "<leader>gs", desc = "summarize text" },
			{ "<leader>gg", desc = "generate git message" },
			{ "<leader>gc", desc = "add comment" }
		},
		opts = {
			models = {
				{
					name = "openai",
					model = "gpt-4-turbo-preview",
					params = nil,
				},
			},
			open_ai = {
				api_key = {
					get = function()
						if __OPENAI_API_KEY then
							return __OPENAI_API_KEY
						else
							local key = vim.fn.system(
								'op read "op://Personal/NeoVim OpenAI/api key"')
							key = string.gsub(key, "\n", "")
							__OPENAI_API_KEY = key
							return key
						end
					end
				}
			},
			shortcuts = {
				{
					name = "textify",
					key = "<leader>gs",
					desc = "fix text with AI",
					use_context = true,
					prompt = [[
						Please rewrite the text to make it more readable, clear,
						concise, and fix any grammatical, punctuation, or spelling
						errors
					]],
					modes = { "v" },
					strip_function = nil,
				},
				{
					name = "commentate",
					key = "<leader>gc",
					desc = "Add comment or documentation to the selected code",
					use_context = true,
					prompt = [[
						Please add comments or documentation for the code below
					]],
					modes = { "v" },
					strip_function = nil,
				},
				{
					name = "gitcommit",
					key = "<leader>gg",
					desc = "generate git commit message",
					use_context = false,
					prompt = function()
						return [[
						    Using the following git diff generate a consise and
						    clear git commit message, with a short title summary
						    that is 75 characters or less:
						]] .. vim.fn.system("git diff --cached")
					end,
					modes = { "n" },
					strip_function = nil,
				},
			},
		}
	},
	-- -- Souce navigation w/ Soucegraph and cody
	-- {
	-- 	"sourcegraph/sg.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	opts = {
	-- 		enable_cody = true,
	-- 	}
	-- },
}
