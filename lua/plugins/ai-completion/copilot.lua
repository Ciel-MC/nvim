return {
	-- Github Copilot library
	'zbirenbaum/copilot.lua',
	event = "InsertEnter",
	build = ":Copilot Auth",
	opts = {
		panel = {
			enabled = false
		},
		suggestion = {
			auto_trigger = true,
			keymap = {
				accept = '<M-Enter>',
			}
		}
	}
}
