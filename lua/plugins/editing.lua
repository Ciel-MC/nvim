return {
    {
        -- surround
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {
            keymaps = {
                insert = "<C-g>gza",
                insert_line = "<C-g>gzA",
                normal = "gza",
                normal_cur = "gzaa",
                normal_line = "gzA",
                normal_cur_line = "gzAA",
                visual = "gza",
                visual_line = "gzA",
            },
            surrounds = {
                F = {
                    add = function()
                        local config = require("nvim-surround.config")
                        local function_name = config.get_input("Enter function name") or ""
                        local language = vim.g.filetype
                        if language == "lua" then
                            local start
                            if function_name then
                                start = "function " .. function_name .. "()"
                            else
                                start = "function()"
                            end
                            return { { start }, { "end" } }
                        elseif language == "rust" then
                            return { { "fn " .. function_name .. "() {" }, { "}" } }
                        end
                    end
                }
            }
        }
    },
    {
        -- Aligning text
        "echasnovski/mini.align",
        -- event = { "BufReadPre", "BufNewFile" },
        keys = {
            { 'ga', mode = { 'n', 'x' }, desc = "Align" },
            { 'gA', mode = { 'n', 'x' }, desc = "Align with preview" }
        },
        opts = {},
        -- config = function(_, opt)
        --     require("mini.align").setup(opt)
        -- end
        main = "mini.align",
    },

    {
        -- Comments
        "echasnovski/mini.comment",
        main = "mini.comment",
        opts = {},
        -- config = function(_, opt)
        --     require("mini.comment").setup(opt)
        -- end
    },

    -- {
    --     'numToStr/Comment.nvim',
    --     dependencies = {
    --         'JoosepAlviste/nvim-ts-context-commentstring',
    --     },
    --     opts = function()
    --         return{
    --             pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    --         }
    --     end,
    --     lazy = false,
    -- },

    -- {
    --     'windwp/nvim-autopairs',
    --     event = 'InsertEnter',
    --     opts = {},
    --     config = function(_, options)
    --         require('nvim-autopairs').setup(options)
    --         local npairs = require('nvim-autopairs')
    --         local Rule = require('nvim-autopairs.rule')
    --         local cond = require 'nvim-autopairs.conds'
    --
    --         -- Add ( | ) expand
    --         local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    --         npairs.add_rules {
    --             Rule(' ', ' ')
    --                 :with_pair(function(opts)
    --                     local pair = opts.line:sub(opts.col - 1, opts.col)
    --                     return vim.tbl_contains({
    --                         brackets[1][1] .. brackets[1][2],
    --                         brackets[2][1] .. brackets[2][2],
    --                         brackets[3][1] .. brackets[3][2],
    --                     }, pair)
    --                 end)
    --         }
    --         for _, bracket in pairs(brackets) do
    --             npairs.add_rules {
    --                 Rule(bracket[1] .. ' ', ' ' .. bracket[2])
    --                     :with_pair(function() return false end)
    --                     :with_move(function(opts)
    --                         return opts.prev_char:match('.%' .. bracket[2]) ~= nil
    --                     end)
    --                     :use_key(bracket[2])
    --             }
    --         end
    --
    --         -- -- Move past commas
    --         -- for _, punct in pairs { ",", ";" } do
    --         --     npairs.add_rules {
    --         --         Rule("", punct)
    --         --             :with_move(function(opts) return opts.char == punct end)
    --         --             :with_pair(function() return false end)
    --         --             :with_del(function() return false end)
    --         --             :with_cr(function() return false end)
    --         --             :use_key(punct)
    --         --     }
    --         -- end
    --
    --         -- Auto expand match arrows
    --         npairs.add_rule(Rule('%(.*%)%s*%=>$', ' {  },', { "rust" })
    --             :use_regex(true)
    --             :set_end_pair_length(3))
    --
    --         -- Add space for assignments
    --         npairs.add_rule(Rule('=', '')
    --             :with_pair(cond.not_inside_quote())
    --             :replace_endpair(function(opts)
    --                 function str(off_start, off_end)
    --                     return opts.line:sub(opts.col + off_start, opts.col + off_end)
    --                 end
    --
    --                 -- Get the next char, if it is space, put nothing, otherwise, put a space
    --                 local next_char = str(0, 0) == ' ' and '' or ' '
    --                 -- If the char before and the one before that is '%w '
    --                 -- In other words, let ow[o ]|
    --                 -- So we should just add the char after the equal
    --                 if str(-2, -1):match('%w ') then
    --                     return next_char
    --                 end
    --                 -- If the characters before are space followed by any amount of equal signs, `return '<bs><bs>=' .. next_char``
    --                 -- E.g.: let owo[ =]|
    --                 if str(-3, -1):match(' = ') then
    --                     return '<bs><bs>=' .. next_char
    --                 end
    --                 return ''
    --             end)
    --             :set_end_pair_length(0)
    --             :with_move(cond.none())
    --             :with_del(cond.none()))
    --     end
    -- },
    {
        'altermo/ultimate-autopair.nvim',
        event = { 'InsertEnter', 'CmdlineEnter' },
        opts = {
            { "<", ">", surround = true, multiline = false },
            config_internal_pairs = {
                -- { "(", ")", nft = { "rust" } },
            }
        }
    },

    { -- Better textobj
        'echasnovski/mini.ai',
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local gen_spec = require("mini.ai").gen_spec
            return {
                custom_textobjects = {
                    F = gen_spec.treesitter({
                        a = '@function.outer',
                        i = '@function.inner',
                    }),
                    c = gen_spec.treesitter({
                        a = { '@conditional.outer', '@loop.outer' },
                        i = { '@conditional.inner', '@loop.inner' },
                    }),
                    C = gen_spec.treesitter({
                        a = { '@class.outer', },
                        i = { '@class.inner', },
                    }),
                    B = gen_spec.treesitter({
                        a = '@block.outer',
                        i = '@block.inner'
                    }),
                    -- a = gen_spec.argument {
                    --     brackets = {
                    --         '%b()', '%b[]', '%b{}', '%b<>',
                    --     },
                    --     separator = ',%s?'
                    -- },

                    a = gen_spec.treesitter({
                        a = '@parameter.outer',
                        i = '@parameter.inner',
                    }),
                },
                n_lines = 50,
                mappings = {
                    goto_left = '[',
                    goto_right = ']',
                },
                -- search_method = 'cover_or_nearest'
            }
        end,
        -- config = function(_, opt)
        --     require("mini.ai").setup(opt)
        -- end
        main = 'mini.ai'
    },
    {
        -- Focus on one buffer
        'folke/zen-mode.nvim',
        dependencies = {
            {
                'folke/twilight.nvim',
                --- @type TwilightOptions
                opts = {
                    expand = {
                        "function",
                        "method",
                        -- Rust
                        "function_item",
                        "trait_item",
                        "struct_item",
                        "mod_item",
                        "const_item",
                        "enum_item",
                        "impl_item",
                        "if_expression",
                        "loop_expression",
                        "while_expression",
                        --- end

                        "if_statement",
                        "block"
                    }
                }
            }
        },
        keys = {
            --- @type LazyKeys
            {
                '<leader>z',
                function()
                    require('zen-mode').toggle {
                        window = { width = .85 }
                    }
                end,
                desc = "Toggle Zen Mode"
            },
        },
        --- @type ZenOptions
        opts = {
            plugins = {
                kitty = {
                    enabled = true
                }
            }
        }
    },
    -- {
    --     -- Advanced search and replace
    --     'nvim-pack/nvim-spectre',
    --     cmd = "Spectre"
    -- },
    -- 'mechatroner/rainbow_csv',

}
