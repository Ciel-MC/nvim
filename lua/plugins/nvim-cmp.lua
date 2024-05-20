return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- Nvim LSP
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
        { 'hrsh7th/cmp-buffer' },
        -- File path completion
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        {
            'Saecki/crates.nvim',
            ft = 'rust',
            opts = {},
        },

        -- Snippets
        {
            'L3MON4D3/LuaSnip',
            opts = {
                history = true,
                region_check_events = "InsertEnter",
                delete_region_events = "TextChanged,InsertLeave"
            }
        },
        'saadparwaiz1/cmp_luasnip',
        -- LSP completion kind Icons
        'onsails/lspkind-nvim',
        -- Snippet collection
        -- {
        --     'rafamadriz/friendly-snippets',
        --     config = function()
        --         require("luasnip.loaders.from_vscode").lazy_load {
        --             exclude = {
        --                 "haskell",
        --             }
        --         }
        --     end,
        -- },
        -- 'windwp/nvim-autopairs',
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'

        local haskell_snippets = require("haskell-snippets").all
        luasnip.add_snippets("haskell", haskell_snippets, { key = "haskell" })
        -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

        -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                cmp.config.sources({
                    name = 'nvim_lsp_document_symbol'
                }),
                { name = 'buffer' },
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })

        cmp.setup {
            completion = {
                keyword_length = 1
            },
            formatting = {
                format = require('lspkind').cmp_format({
                    mode = 'symbol_text',
                    -- maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                }),
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- elseif luasnip.expand_or_jumpable() then
                    --     luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'cody' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'crates' },
                { name = 'vim-dadbod-completion' },
                { name = 'path' },
            },
            window = {
                -- documentation = cmp.config.window.bordered(),
                -- Use Noice for floating window
                completion = cmp.config.window.bordered()
            },
            performance = {
                throttle = 0
            }
        }
    end
}
