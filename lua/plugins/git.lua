return {
    -- Git related plugins
    {
        'tpope/vim-fugitive',
        cmd = { "G", "Git" }
    },
    -- Github integration
    -- 'tpope/vim-rhubarb',
    -- Git signs
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile', },
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        }
    },
    -- Gitignore generator
    {
        'wintermute-cell/gitignore.nvim',
        cmd = { 'Gitignore' },
        dependencies = {
            'nvim-telescope/telescope.nvim'
        },
    },
    -- -- Git worktrees
    -- {
    --     'ThePrimeagen/git-worktree.nvim',
    --     config = true
    -- },

    -- {
    --     'NeogitOrg/neogit',
    --     dependencies = 'nvim-lua/plenary.nvim',
    --     opts = {}
    -- }
}
