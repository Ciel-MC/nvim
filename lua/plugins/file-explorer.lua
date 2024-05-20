return {
    -- {
    --     'imNel/monorepo.nvim',
    --     dependencies = {
    --         'nvim-telescope/telescope.nvim',
    --         'nvim-lua/plenary.nvim'
    --     },
    --     keys = {
    --         {
    --             '<leader>sr',
    --             function()
    --                 require('telescope').extensions.monorepo.monorepo()
    --             end
    --         }
    --     },
    --     -- init = function()
    --     --     vim.api.nvim_create_autocmd("SessionSavePre", {
    --     --
    --     --     })
    --     -- end,
    --     opts = {}
    -- },
    {
        'echasnovski/mini.files',
        keys = {
            {
                "<leader>mf",
                function()
                    require("mini.files").open()
                end
            }
        },
        main = "mini.files",
        -- config = function(_, opt)
        --     require("mini.files").setup(opt)
        -- end,
        opts = {},
    }
}
