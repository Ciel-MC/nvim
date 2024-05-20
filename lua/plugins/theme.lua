return {
    {
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        lazy = true,
        opts = {
            -- style = 'darker',
            style = 'warmer',
            -- transparent = true,
            ending_tildes = true,
        },
    },
    -- {
    --     "fabius/molokai.nvim",
    --     dependencies = "rktjmp/lush.nvim",
    --     lazy = false,
    -- },
    -- {
    --     'EdenEast/nightfox.nvim',
    --     opts = {
    --         options = {
    --             transparent = not vim.g.neovide
    --         }
    --     }
    -- },
    -- {
    --     -- Alternative onedark
    --     'olimorris/onedarkpro.nvim',
    -- },
    {
        -- Twanspawency
        'xiyaowong/transparent.nvim',
        init = function()
            vim.g.transparent_enabled = not vim.g.neovide
        end,
        opts = {
            -- enable = true,
            extra_groups = {
                -- File Explorer
                -- "NeoTreeNormal",
                -- "NeoTreeNormalNC",
                -- "NeoTreeEndOfBuffer",
            },
        },
        config = function(_, opts)
            require('transparent').setup(opts)
        end
    },
}
