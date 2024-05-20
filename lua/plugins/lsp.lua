local Utils = require 'plugins.utils.utils'
return {
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        cond = not vim.g.vscode,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            -- Additional lua configuration, makes nvim stuff amazing
            { 'folke/neodev.nvim', opts = {} },
            -- Language server settings
            -- { "folke/neoconf.nvim",            cmd = "Neoconf", config = true },
            -- Automatically install LSPs to stdpath for neovim
        },
    },
    { 'williamboman/mason.nvim', cmd = "Mason", cond = not require('nixCatsUtils').isNixCats, opts = {} },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        cond = not require('nixCatsUtils').isNixCats,
        opts = {
            -- ensure_installed = {
            --     "clangd",
            --     "html",
            --     "tsserver",
            --     "eslint",
            --     "taplo",
            --     "pylsp",
            --     "texlab",
            -- "rust_analyzer",
            --     "jsonls",
            --     "lua_ls",
            -- },
        },
        config = function(opts)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local lspconfig = require 'lspconfig'
            local handlers = {
                function(server_name) -- default handler (optional)
                    lspconfig[server_name].setup {}
                end,
            }
            for name, config in pairs(Utils.servers) do
                handlers[name] = function()
                    -- vim.notify(name..'\n'..vim.inspect(config))
                    lspconfig[name].setup {
                        capabilities = capabilities,
                        on_attach = Utils._on_attach,
                        settings = config,
                        cmd = config.cmd
                    }
                end
            end
            require 'mason-lspconfig'.setup_handlers(handlers)
        end
    },

    -- -- Lsp bridge
    -- {
    --     'jose-elias-alvarez/null-ls.nvim',
    --     cond = not vim.g.vscode,
    --     event = 'LspAttach',
    --     opts = function()
    --         local nls = require('null-ls')
    --         return {
    --             sources = {
    --                 -- Add gitsign as code action source
    --                 nls.builtins.code_actions.gitsigns,
    --                 -- GitHub Action file linting
    --                 nls.builtins.diagnostics.actionlint,
    --                 -- Protocol buffer support
    --                 -- nls.builtins.diagnostics.buf,
    --                 -- Fish shell support
    --                 nls.builtins.diagnostics.fish,
    --                 nls.builtins.formatting.fish_indent,
    --                 -- Git commit message lint
    --                 nls.builtins.diagnostics.gitlint,
    --                 -- GLSL support
    --                 nls.builtins.diagnostics.glslc,
    --                 -- TS-node-action
    --                 -- nls.builtins.code_actions.ts_node_action,
    --             }
    --         }
    --     end
    -- },

    -- {
    --     -- Inline diagnostics display
    --     'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    --     event = 'LspAttach',
    --     init = function()
    --         vim.diagnostic.config {
    --             -- underline = true,
    --             virtual_text = false,
    --             -- signs = false,
    --             update_in_insert = false,
    --         }
    --     end,
    --     keys = {
    --         {
    --             '<M-d>',
    --             function()
    --                 require("lsp_lines").toggle()
    --             end,
    --             desc = 'Toggle [D]iagnostics'
    --         }
    --     },
    --     config = true
    -- },

    -- {
    --     'aznhe21/actions-preview.nvim',
    --     cond = not vim.g.vscode,
    --     lazy = true,
    --     opts = {}
    -- },

    {
        "luckasRanarison/clear-action.nvim",
        opts = {
            signs = {
                enable = false
            },
            popup = {
                center = true
            },
            mappings = {
                code_action = {
                    "<leader>a",
                }
            }
        }
    },

    {
        -- diagnostics
        'folke/trouble.nvim',
        cond = not vim.g.vscode,
        cmd = 'TroubleToggle',
        opts = {
            use_diagnostic_signs = true
        }
    },

    {
        -- Definition or reference
        'KostkaBrukowa/definition-or-references.nvim',
        keys = {
            {
                'gd',
                function()
                    require('definition-or-references').definition_or_references()
                end,
                desc = '[G]o to [D]efinition or references'
            }
        },
        opts = function()
            local make_entry = require "telescope.make_entry"
            local pickers = require "telescope.pickers"
            local finders = require("telescope.finders")

            local function filter_entries(results)
                local current_file = vim.api.nvim_buf_get_name(0)
                local current_line = vim.api.nvim_win_get_cursor(0)[1]

                local function should_include_entry(entry)
                    -- if entry is on the same line
                    if entry.filename == current_file and entry.lnum == current_line then
                        return false
                    end

                    -- if entry is closing tag - just before it there is a closing tag syntax '</'
                    if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == "</" then
                        return false
                    end

                    return true
                end

                return vim.tbl_filter(should_include_entry, vim.F.if_nil(results, {}))
            end

            local function handle_references_response(result)
                local locations = vim.lsp.util.locations_to_items(result, "utf-8")
                local filtered_entries = filter_entries(locations)
                pickers
                    .new({}, {
                        prompt_title = "LSP References",
                        finder = finders.new_table({
                            results = filtered_entries,
                            entry_maker = make_entry.gen_from_quickfix(),
                        }),
                        previewer = require("telescope.config").values.qflist_previewer({}),
                        sorter = require("telescope.config").values.generic_sorter({}),
                        push_cursor_on_edit = true,
                        push_tagstack_on_edit = true,
                        initial_mode = "normal",
                    })
                    :find()
            end
            return {
                on_references_result = handle_references_response,
            }
        end
    },
}
