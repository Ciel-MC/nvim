return {
    { -- easily jump to any location and enhanced f/t motions for Leap
        "ggandor/leap.nvim",
        -- event = { "BufReadPost", "BufNewFile", },
        dependencies = {
            -- {
            --     "ggandor/flit.nvim",
            --     "tpope/vim-repeat",
            --     opts = {},
            --     keys = {
            --         'f', 'F', 't', 'T',
            --     }
            -- },
            -- {
            --     'ggandor/leap-spooky.nvim',
            --     config = true
            -- }
        },
        keys = { "s", "S" },
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },
    { -- Inter-file navigation
        'ThePrimeagen/harpoon',
        keys = {
            {
                '<leader>hh',
                function()
                    require('harpoon.ui').toggle_quick_menu()
                end,
                { mode = { 'n', 'o', 'x' }, desc = "Harpoon quick menu" }
            },
            {
                '<leader>ha',
                function()
                    require('harpoon.mark').add_file()
                end,
                { mode = { 'n', 'o', 'x' }, desc = "Harpoon add file" }
            },
            {
                '<leader>1',
                function()
                    require('harpoon.ui').nav_file(1)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 1"
            },
            {
                '<leader>2',
                function()
                    require('harpoon.ui').nav_file(2)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 2"
            },
            {
                '<leader>3',
                function()
                    require('harpoon.ui').nav_file(3)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 3"
            },
            {
                '<leader>4',
                function()
                    require('harpoon.ui').nav_file(4)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 4"
            },
            {
                '<leader>5',
                function()
                    require('harpoon.ui').nav_file(5)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 5"
            },
            {
                '<leader>6',
                function()
                    require('harpoon.ui').nav_file(6)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 6"
            },
            {
                '<leader>7',
                function()
                    require('harpoon.ui').nav_file(7)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 7"
            },
            {
                '<leader>8',
                function()
                    require('harpoon.ui').nav_file(8)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 8"
            },
            {
                '<leader>9',
                function()
                    require('harpoon.ui').nav_file(9)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 9"
            },
            {
                '<leader>0',
                function()
                    require('harpoon.ui').nav_file(10)
                end,
                mode = { 'n', 'o', 'x' },
                desc = "Harpoon goto file 10"
            },
        },
        -- config = function(_, opts)
        --     require('harpoon').setup(opts)
        -- end
    },
    { --  Alternative w, e, and b that considers casing.
        'chrisgrieser/nvim-spider',
        lazy = true,
        keys = {
            {
                'w',
                function()
                    require("spider").motion("w")
                end,
                { mode = { 'n', 'o', 'x' }, desc = "Spider override for w" }
            },
            {
                'e',
                function()
                    require("spider").motion("e")
                end,
                { mode = { 'n', 'o', 'x' }, desc = "Spider override for e" }
            },
            {
                'b',
                function()
                    require("spider").motion("b")
                end,
                { mode = { 'n', 'o', 'x' }, desc = "Spider override for b" }
            }
        }
    },
}
