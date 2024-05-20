local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local heirline = require("heirline")

local colors = require("onedark.colors")
heirline.load_colors(colors)

local escape = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- @param tbl string[]
local surround = function(tbl, component)
	return utils.surround(tbl, function(self) return self:color() end, component)
end

local prepend = function(tbl, component)
	return utils.clone(tbl, component)
end

local insert = utils.insert

local Space = { provider = " ", }

local Separator = { provider = " | ", }

local Align = { provider = "%=", }

-- vim.api.nvim_create_autocmd("ModeChanged", { pattern = "*", callback = function() local mode = vim.fn.mode(1) require("notify")(mode) end })

local ViMode = {
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	{
		{
			provider = function(self)
				return self.mode_names[self.mode]
			end,
			hl = function(self)
				return {
					fg = "black",
					bg = self:color(),
					bold = true,
				}
			end,
		}
	}
}

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b["gitsigns_status_dict"]
	end,

	hl = { fg = "orange", bold = true },

	{
		Space,
		-- git branch name
		{
			provider = function(self)
				local branch = self.status_dict.head
				if branch == "" then
					branch = "[No Branch]"
				end
				return " " .. branch
			end
		},
		Space,
	},
}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	flexible = 5,
}
-- We can now define some children separately and add them later

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
			{ default = true })
	end,
	{
		provider = function(self)
			return self.icon and (self.icon .. " ")
		end,
		hl = function(self)
			return { fg = self.icon_color }
		end
	},
	{ provider = "" }
}

local FileName = {
	init = function(self)
		-- first, trim the pattern relative to the current directory. For other
		-- options, see :h filename-modifers
		self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
		if self.lfilename == "" then self.lfilename = "[No Name]" end
	end,
	hl = function()
		if vim.bo.modified then
			return { fg = "green", bold = true }
		end
	end,

	flexible = 4,
	{
		provider = function(self)
			return self.lfilename
		end
	},
	{
		provider = function(self)
			return vim.fn.pathshorten(self.lfilename)
		end
	}
}

local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "[+]",
		hl = { fg = "green" },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "",
		hl = { fg = "orange" },
	},
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
	{ FileIcon, FileName, FileFlags },
	{ FileName }
-- { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
	provider = function()
		return vim.bo.filetype
	end,
}

local FileEncoding = {
	static = {
		encoding = function()
			return (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
		end
	},
	condition = function(self)
		return self:encoding() ~= 'utf-8'
	end,
	provider = function(self)
		return self:encoding():upper()
	end,
	{ provider = "|" },
}

local FileFormat = {
	condition = function()
		return vim.bo.fileformat ~= 'unix'
	end,
	provider = function()
		return vim.bo.fileformat:upper()
	end,
	{ provider = "|" },
}

local FileTypeInfo = utils.insert({},
	FileType,
	FileEncoding,
	FileFormat
)

-- We're getting minimalists here!
local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	-- %P = percentage through file of displayed window
	provider = "%l/%L(%P)",
}

-- I take no credits for this! :lion:
local ScrollBar = {
	static = {
		sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
	},
	provider = function(self)
		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_line_count(0)
		local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
		return string.rep(self.sbar[i], 2)
	end,
	hl = { fg = "blue" },
}

local LSPActive = {
	condition = conditions.lsp_attached,
	hl        = { fg = "green", bold = true },
	flexible  = 1,
	{
		update   = { 'LspAttach', 'LspDetach' },
		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end
			return " [" .. table.concat(names, " ") .. "]"
		end
	},
	{ provider = " [LSP]" },
}

local DAPMessages = {
	condition = function()
		-- Check if DAP has been loaded yet
		for _, p in ipairs(require('lazy').plugins()) do
			if p.name == 'nvim-dap' and not p._.loaded then
				return false
			end
		end
		local session = require("dap").session()
		return session ~= nil
	end,
	provider = function()
		return " " .. require("dap").status()
	end,
	hl = "Debug"
	-- see Click-it! section for clickable actions
}

local MacroRec = {
	condition = function()
		return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
	end,
	provider = "",
	hl = { fg = "red", bold = true },
	{
		utils.surround({ "[", "]" }, nil,
			{ provider = function() return vim.fn.reg_recording() end }),
		hl = { fg = "orange", bold = true },
	},
	update = {
		"RecordingEnter",
		"RecordingLeave",
	}
}

local ActiveStatusLine = {
	condition = conditions.is_active,
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	static = {
		mode_names = {
			n = "NORMAL",
			no = "OPERATOR-PENDING",
			nov = "VISUAL OPERATOR-PENDING",
			noV = "VISUAL(LINE) OPERATOR-PENDING",
			[escape("no<C-V>")] = "<C-V> OPERATOR-PENDING",
			niI = "NORMAL(INSERT)",
			niR = "NORMAL(REPLACE)",
			niV = "NORMAL(VIRTUAL-REPLACE)",
			nt = "TERMINAL-NORMAL",
			ntT = "NORMAL(TERMINAL)",
			v = "VISUAL",
			vs = "VISUAL(SELECT)",
			V = "VISUAL(LINE)",
			Vs = "VISUAL(LINE)(SELECT)",
			[escape("<C-V>")] = "VISUAL(BLOCK)",
			[escape("<C-V>s")] = "VISUAL(BLOCK)(SELECT)",
			s = "SELECT",
			S = "SELECT(LINE)",
			[escape("<C-S>")] = "SELECT(BLOCK)",
			i = "INSERT",
			ic = "INSERT(COMPLETION)",
			ix = "INSERT(COMPLETION)",
			R = "REPLACE",
			Rc = "REPLACE(COMPLETION)",
			Rx = "REPLACE(COMPLETION)",
			Rv = "VIRTUAL-REPLACE",
			Rvc = "VIRTUAL-REPLACE(COMPLETION)",
			Rvx = "VIRTUAL-REPLACE(COMPLETION)",
			c = "COMMAND-LINE EDITING",
			cv = "EX-MODE",
			r = "HIT-ENTER PROMPT",
			rm = "MORE PROMPT",
			["r?"] = "CONFIRM QUERY",
			["!"] = "SHELL/EXTERNAL COMMAND",
			t = "TERMINAL-MODE",
		},
		mode_colors = {
			n = "green",
			i = "blue",
			v = "purple",
			V = "purple",
			[escape("<C-V>")] = "purple",
			c = "orange",
			s = "purple",
			S = "purple",
			[escape("<C-S>")] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = "red",
		},
		color = function(self)
			return self.mode_colors[self.mode:sub(1, 1)]
		end
	},
	{
		hl = { bg = "bg0" },
		surround({ "", "" }, {
			utils.surround({ " ", " " }, nil, ViMode)
		}),
	},
	{
		hl = { bg = "bg0" },
		Space,
		FileNameBlock,
		-- prepend(Separator, Diagnostics),
		prepend(Separator, DAPMessages),
		Space,
	},
	{
		hl = { bg = "bg1" },
		flexible = 3,
		fallthrough = false,
		Git,
		{ provider = '' }
	},

	{
		hl = { bg = "bg2" },
		Align,
	},

	{
		hl = { bg = "bg1" },
		Space,
		-- {
		-- 	ShowCmd,
		-- 	hl = { bg = "blue" },
		-- },
		insert(MacroRec, Space),
		insert(FileTypeInfo, Space),
	},
	{
		hl = { bg = "bg0" },
		flexible = 1,
		fallthrough = false,
		LSPActive,
		{ provider = '' }
	},
	{
		hl = { bg = "bg0" },
		surround({ "", "" }, {
			hl = function(self) return { fg = "black", bg = self:color() } end,
			Space,
			Ruler,
			ScrollBar,
		})
	}
}

local FallbackStatusLine = {
	hl = "StatusLineNC",
	FileNameBlock,
}

local opts = {
	statusline = {
		fallthrough = false,
		ActiveStatusLine,
		FallbackStatusLine,
	}
}

return opts
