if not nixCats("treesitter") then
    return {}
end
return {
    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        cond = not vim.g.vscode,
        -- event = { 'BufReadPost', 'BufNewFile', },
        event = "LspAttach",
        dependencies = {
            -- 'nvim-treesitter/playground',
            -- Additional text objects via treesitter
            'nvim-treesitter/nvim-treesitter-textobjects',
            { 'nvim-treesitter/nvim-treesitter-context', config = true },
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                "fish",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "glsl",
                "hlsl",
                "html",
                "java",
                "javascript",
                "json",
                "jsonc",
                "kdl",
                "kotlin",
                "latex",
                "lua",
                "markdown",
                "markdown_inline",
                "nix",
                "python",
                "query",
                "regex",
                "ron",
                "rust",
                "scheme",
                "todotxt",
                "toml",
                "vim",
                "vimdoc",
                "vue",
                "wgsl",
                "wgsl_bevy",
            },

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    node_decremental = '<c-backspace>',
                },
            },
            textobjects = {
                select = {
                    keymaps = {
                        ['gc'] = "@comment",
                    }
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    floating_preview_opts = {},
                    -- peek_definition_code = {
                    --     ["<leader>df"] = "@function.outer",
                    --     -- ["<leader>dF"] = "@class.outer",
                    -- }
                }
            }
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]]
            -- See `:help nvim-treesitter`
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    {
        -- Split and join with treesitter
        'Wansmer/treesj',
        keys = {
            {
                '<leader>m',
                function()
                    require('treesj').toggle()
                end,
                desc = "Toggle split/join"
            },
        },
        opts = {
            use_default_keymaps = false,
        },
    },

    {
        'ckolkey/ts-node-action',
        keys = {
            {
                '<leader>o',
                function()
                    require('ts-node-action').node_action()
                end,
                desc = "Node action"
            }
        },
    },

    -- {
    --     'windwp/nvim-ts-autotag',
    --     ft = {
    --         'astro',
    --         'glimmer',
    --         'handlebars',
    --         'html',
    --         'javascript',
    --         'jsx',
    --         'markdown',
    --         'php',
    --         'rescript',
    --         'svelte',
    --         'tsx',
    --         'typescript',
    --         'vue',
    --         'xml',
    --     },
    --     opts = {},
    --     config = true,
    -- },
}
