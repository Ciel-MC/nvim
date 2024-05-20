return {
	'Exafunction/codeium.vim',
	event = "InsertEnter",
	-- build = ":Codeium Auth",
	init = function()
		vim.g.codeium_disable_bindings = 1
	end,
	keys = {
		{
			"<M-Enter>",
			function()
				return vim.fn["codeium#Accept"]()
			end
			-- function()
			--     local function replace(code)
			--         return vim.api.nvim_replace_termcodes(code, true, true, true)
			--     end
			--     local input = vim.fn["codeium#Accept"]()
			--     -- print("Input ")
			--     print(input)
			--     local test_string = replace [[ <ESC>x0d(%d+)li<C-R><C-O>=codeium#CompletionText%(%)<CR>]]
			--     local test_move = replace [[<C-O>:exe 'go' line2byte%(line%('%.'%)%)%+col%('%.'%)%+%((%-?%d+)%)]]
			--     -- print(test_string)
			--     -- print(test_move)
			--     local delete_right = tonumber(string.match(input, test_string)) or 0
			--     local move_back = tonumber(string.match(input, test_move)) or 0
			--     -- print("Delete right " .. delete_right)
			--     -- print("Move back " .. move_back)
			--     local completion_text = vim.fn["codeium#CompletionText"]()
			--     -- print(completion_text)
			--     local lines = {}
			--     for s in completion_text:gmatch("[^\r\n]+") do
			--         table.insert(lines, s)
			--     end
			--     local current_pos = vim.api.nvim_win_get_cursor(0)
			--     local current_row = current_pos[1]
			--     -- local current_col = current_pos[2]
			--     vim.schedule(function()
			--         vim.api.nvim_buf_set_text(0, current_row - 1, 0, current_row - 1, delete_right, lines)
			--         local index = vim.fn.line2byte(vim.fn.line(".")) + vim.fn.col(".") - 1 - delete_right +
			--             completion_text:len() + move_back
			--         -- print(index)
			--         vim.cmd.go { count = index }
			--         -- vim.api.nvim_input(completion_text)
			--     end)
			--     -- vim.api.nvim_input(vim.fn["codeium#CompletionText"]())
			--     -- end
			-- end
			,
			desc = "Accept Codeium suggestion",
			mode = { "i" },
			expr = true
		},
		{
			"<M-\\>",
			function()
				vim.api.nvim_input("")
			end,
			desc = "Trigger Codeium completion",
			mode = { "i" },
			expr = true
		}
	}
}
