local M = {}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
M.servers = {
    clangd = {
        cmd = {
            'clangd',
            '--offset-encoding=utf-16',
        }
    },
    -- gopls = {},
    -- pyright = {},
    rust_analyzer = {
        -- cmd = { 'rust-anaylzer' },
        ["rust-analyzer"] = {
            imports = {
                preferPrelude = true,
            },
            check = {
                command = 'clippy',
                extraArgs = {
                    '--',
                    '-Wclippy::pedantic',
                    '-Wclippy::nursery',
                    -- '-Wclippy::cargo',
                    '-Wclippy::unwrap_used',
                },
                features = "all"
            },
            cargo = {
                -- target = "x86_64-pc-windows-gnu"
            },
            completion = {
                snippets = {
                    custom = {

                        ["Arc::new"] = {
                            postfix = "arc",
                            body = "Arc::new(${receiver})",
                            requires = "std::sync::Arc",
                            description = "Put the expression into an `Arc`",
                            scope = "expr"
                        },
                        ["Rc::new"] = {
                            postfix = "rc",
                            body = "Rc::new(${receiver})",
                            requires = "std::rc::Rc",
                            description = "Put the expression into an `Rc`",
                            scope = "expr"
                        },
                        ["Box::pin"] = {
                            postfix = "pinbox",
                            body = "Box::pin(${receiver})",
                            requires = "std::boxed::Box",
                            description = "Put the expression into a pinned `Box`",
                            scope = "expr"
                        },
                        ["Ok"] = {
                            postfix = "ok",
                            body = "Ok(${receiver})",
                            description = "Wrap the expression in a `Result::Ok`",
                            scope = "expr"
                        },
                        ["Err"] = {
                            postfix = "err",
                            body = "Err(${receiver})",
                            description = "Wrap the expression in a `Result::Err`",
                            scope = "expr"
                        },
                        ["Some"] = {
                            postfix = "some",
                            body = "Some(${receiver})",
                            description = "Wrap the expression in an `Option::Some`",
                            scope = "expr"
                        },
                        ["Option"] = {
                            postfix = "option",
                            body = "Option<${receiver}>",
                            description = "Wrap the type in an `Option`",
                            scope = "type"
                        }
                    }
                }
            }
        }
    },
    -- tsserver = {},

    lua_ls = {
        Lua = {
            -- workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            defaultConfig = {
                indent_style = "space",
                indent_size = "4"
            }
        },
    },
}

if require('nixCatsUtils').isNixCats then
    M.servers['nixd'] = {}
end

local attach_listeners = {}

M.add_on_attach = function(func)
    table.insert(attach_listeners, func)
end

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
M._on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc, opts)
        if desc then
            desc = 'LSP: ' .. desc
        end

        opts = vim.tbl_deep_extend('keep', opts or {}, {
            mode = 'n',
        })

        vim.keymap.set(opts.mode, keys, func, { buffer = bufnr, desc = desc })
    end
    nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
    -- nmap('<leader>aa', require('clear-action.actions').code_action, 'Code [A]ction')
    -- nmap('<leader>a', 'Code [A]ction', require('clear-action.actions').code_action)
    -- nmap('<leader>a', vim.lsp.buf.code_action, 'Code [A]ction')
    -- nmap('<leader>a', require("actions-preview").code_actions, 'Code [A]ction', { mode = { 'n', 'v' } })

    nmap('<leader>f', function() vim.lsp.buf.format { async = true } end, '[F]ormat')

    -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Search Document [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_workspace_symbols, 'Search Workspace [S]ymbols')

    if vim.version().minor >= 10 then
        nmap('<leader>l', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            "Toggle In[l]ay Hints")
    end

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('m', vim.diagnostic.open_float, 'Diagnostic')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Diagnostic keymaps
    nmap('<leader>sd', function() require('telescope.builtin').diagnostics { bufnr = 0 } end,
        '[S]earch [D]iagnostics')
    nmap('<leader>sD', function() require('telescope.builtin').diagnostics() end, '[S]earch [D]iagnostics')
    nmap(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic')
    nmap('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic')
    for _, listener in ipairs(attach_listeners) do
        listener(client, bufnr, nmap)
    end

end
return M
