local Utils = require('plugins.utils.utils')
return {
    -- 'Ciel-MC/rust-tools.nvim',
    -- cond = not vim.g.vscode,
    -- dev = true,
    -- ft = 'rust',
    -- dependencies = { 'mattn/webapi-vim', 'nvim-lua/plenary.nvim',
    --     { 'chrishrb/gx.nvim', config = true } },
    -- opts = {
    --     server = {
    --         on_attach = Utils._on_attach,
    --         settings = Utils.servers.rust_analyzer
    --     },
    --     tools = {
    --         cargo_wrapper = true,
    --         browser = function(url)
    --             require("gx.shell").execute_with_error(
    --                 require('gx').options.open_browser_app,
    --                 require('gx').options.open_browser_args,
    --                 url
    --             )
    --         end,
    --         runnables = {
    --             use_telescope = true,
    --         },
    --         inlay_hints = {
    --             auto = false,
    --             -- show_parameter_hints = true,
    --             -- parameter_hints_prefix = ': ',
    --             -- other_hints_prefix = ': ',
    --         }
    --     },
    -- },
    -- config = function(_, opts)
    --     local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.10.0-universal"
    --     local codelldb_path = extension_path .. 'adapter/codelldb'
    --     local liblldb_path = extension_path .. 'lldb/lib/liblldb'
    --     local this_os = vim.loop.os_uname().sysname;
    --     liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    --
    --     opts.dap = {
    --         adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    --     }
    --
    --     Utils.add_on_attach(function(client, bufnr)
    --         if client.name == "rust_analyzer" then
    --             local map = function(keys, func, desc, options)
    --                 options = options or {}
    --                 if desc then
    --                     desc = 'Rust: ' .. desc
    --                 end
    --
    --                 vim.keymap.set(options.mode or 'n', keys, func, { buffer = bufnr, desc = desc })
    --             end
    --             map('<leader>R', require('rust-tools.runnables').runnables, '[R]un Rust')
    --             map('<leader>D', require('rust-tools.debuggables').debuggables, '[D]ebug Rust')
    --
    --
    --             map('K', require('rust-tools.hover_range').hover_range, 'LSP Hover', { mode = { 'n', 'v' } })
    --         end
    --     end)
    --
    --     require('rust-tools').setup(opts)
    -- end

    'mrcjkb/rustaceanvim',
    cond = not vim.g.vscode,
    lazy = false,
    dependencies = { 'mattn/webapi-vim', 'nvim-lua/plenary.nvim', { 'chrishrb/gx.nvim', config = true } },
    --- @type RustaceanOpts
    opts = {
        server = {
            on_attach = Utils._on_attach,
            settings = Utils.servers.rust_analyzer
        },
        tools = {
            open_url = function(url)
                require("gx.shell").execute_with_error(
                    require('gx').options.open_browser_app,
                    require('gx').options.open_browser_args,
                    url
                )
            end,
            executor = 'termopen',
            test_executor = 'termopen',
            crate_test_executor = 'termopen',
            float_win_config = {
                open_split = 'horizontal',
                border = nil
            }
        },
    },
    config = function(_, opts)
        local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.10.0-universal"
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb'
        local this_os = vim.loop.os_uname().sysname;
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")

        opts.dap = {
            adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path)
        }

        Utils.add_on_attach(function(client, bufnr)
            if client.name == "rust-analyzer" then
                local map = function(keys, func, desc, options)
                    options = options or {}
                    if desc then
                        desc = 'Rust: ' .. desc
                    end

                    vim.keymap.set(options.mode or 'n', keys, func, { buffer = bufnr, desc = desc })
                end
                map('<leader>R', function() vim.cmd.RustLsp('runnables') end, '[R]un Rust')
                map('<leader>D', function() vim.cmd.RustLsp('debuggables') end, '[D]ebug Rust')
                map('M', function() vim.cmd.RustLsp('renderDiagnostic') end, 'Render diagnostics')

                map('K', function()
                    vim.cmd.RustLsp { 'hover', 'actions' }
                end, 'LSP Hover', { mode = { 'n' } })
                map('K', function()
                    vim.cmd.RustLsp { 'hover', 'range' }
                end, 'LSP Hover', { mode = { 'v' } })
            end
        end)

        vim.g.rustaceanvim = opts
    end
}
