return {
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        cond = not vim.g.vscode,
        event = 'BufReadPost',
        main = 'ibl',
        opts = {
            scope = {
                enabled = true
            }
        }
    },

    {
        -- Custom lines
        'rebelot/heirline.nvim',
        cond = not vim.g.vscode,
        dependencies = { 'navarasu/onedark.nvim' },
        opts = function()
            return require('plugins.config.heirline')
        end
    },

    {
        'echasnovski/mini.hipatterns',
        main = 'mini.hipatterns',
        opts = function()
            local hipatterns = require('mini.hipatterns')
            return {
                highlighters = {
                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                }
            }
        end,
        -- config = function(_, opt)
        --     require("mini.hipatterns").setup(opt)
        -- end
    },
    -- Highlight TODOs
    {
        'folke/todo-comments.nvim',
        cmd = { "TodoTelescope" },
        event = { "BufReadPre", "BufNewFile" },
        config = true,
        keys = {
            { "]t",        function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",        function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>t", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
        },
        --- @type TodoConfig
        opts = {
            keywords = {
                TODO = {
                    alt = { "todo", "unimplemented", }
                }
            },
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*(:|!\()]],
                comments_only = false
            },
            search = {
                pattern = [[\b(KEYWORDS)(:|!\()]]
            }
        }
    },
    -- New UI
    {
        'folke/noice.nvim',
        cond = not vim.g.vscode and not vim.g.started_by_firenvim,
        event = 'VimEnter',
        dependencies = {
            -- Notifications
            {
                'rcarriga/nvim-notify',
                event = 'BufWinEnter',
                opts = {
                    timeout = 500,
                    background_colour = '#1e222a',
                }
            },
            {
                -- Renaming prompt
                'stevearc/dressing.nvim',
                event = 'LspAttach',
            },
        },
        ---@type NoiceConfig
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                }
            },
            presets = {
                -- inc_rename = true,
                command_palette = true,
            },
            --- @type NoiceFormatOptions
            format = {
                spinner = {
                    name = "firaCode"
                }
            }
        }
    },

    {
        -- Window manager
        'folke/edgy.nvim',
        event = "VeryLazy",
        --- @type Edgy.Config
        opts = {
            wo = {
                winhighlight = ""
            },
            ---@type (Edgy.View.Opts|string)[]
            bottom = {
                -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
                {
                    ft = "toggleterm",
                    size = { height = 0.4 },
                    -- exclude floating windows
                    filter = function(_, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
                "Trouble",
                { ft = "qf",            title = "QuickFix" },
                {
                    ft = "help",
                    size = { height = 20 },
                    -- only show help buffers
                    filter = function(buf)
                        return vim.bo[buf].buftype == "help"
                    end,
                },
                { ft = "spectre_panel", size = { height = 0.4 } },
            }, ---@type (Edgy.View.Opts|string)[]
            right = {}, ---@type (Edgy.View.Opts|string)[]
            top = {}, ---@type (Edgy.View.Opts|string)[]
        }
    },
    {
        -- Register preview
        'tversteeg/registers.nvim',
        event = { 'BufReadPost', 'BufNewFile', },
        config = true
    },
    {
        'tzachar/highlight-undo.nvim',
        keys = {
            { 'u',     desc = "Undo", },
            { '<C-r>', desc = "Redo", }
        },
        opts = {}
    },
    "kyazdani42/nvim-web-devicons",
}
