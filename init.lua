vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.showmode = false

vim.opt.smartindent = true
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 8
vim.opt.timeoutlen = 100

-- :intro to see startupscreen for some reason whichkey verylazy messes it up for me
vim.opt.shortmess:append({ I = true })

vim.opt.wrap = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.netrw_banner = 0

vim.opt.smartcase = true
vim.opt.ignorecase = true
-- TODO i think i would like to highlight then turn it off
-- vim.opt.hlsearch = false

vim.opt.laststatus = 3

-- still not sure this does anything
vim.opt.termguicolors = true

-- copy handled by kitty "control-c"
-- "control-v" to paste
vim.opt.clipboard = 'unnamedplus'
-- seems i dont need anything else?? do i need registers?
vim.opt.mouse = 'a'
vim.opt.mousefocus = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.g.mapleader = ' '
vim.g.maplocalleader = ',' -- what is this?

-- SF i forget about this
local opts = { noremap = true }

vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('v', ';', ':', opts)

-- move lines, this is pretty nice
-- TODO get this desc thing down for whichkey
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move line down' })
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv")

vim.keymap.set('n', '<leader>q', '<cmd>q!<cr>', { desc = 'quit without saving' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'write' })
vim.keymap.set('n', '<leader>x', '<cmd>update<cr><cmd>q<cr>', { desc = 'save and quit' })
vim.keymap.set('n', '<leader>m', '<cmd>update<cr><cmd>!make --keep-going<cr>', { desc = 'make' })

vim.keymap.set('n', 'Q', 'q', opts)
vim.keymap.set('n', 'q', '<Nop>')

-- whats going on here?
-- local autocmd = vim.api.nvim_create_autocmd
-- local yank_group = augroup("HighlightYank", {})
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- require("lazy").setup(plugins, opts)
require('lazy').setup({
    {
        'folke/tokyonight.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('current-theme')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = 'all',
                sync_install = true,
                auto_install = true,
                ignore_install = {},
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                modules = {}, -- SF not too sure about this one, fixes linting error
            })
        end,
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
        -- config = function() require('Comment').setup() end
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        -- config = function() require('which-key').setup() end
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {}, -- this is equalent to setup({}) function
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        -- lazy = true,
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'Telescope',
        keys = { { '<leader>ff', '<cmd>Telescope find_files<cr>' } },
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        -- cmd = { 'LspInfo' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'mfussenegger/nvim-lint',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'folke/neodev.nvim',
        },
        config = function()
            local mason = require('mason')
            local mason_tool_installer = require('mason-tool-installer')

            mason.setup({
                ui = {
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗',
                    },
                },
            })

            mason_tool_installer.setup({
                ensure_installed = {
                    'luacheck',
                    'stylua',
                    'shellcheck',
                    'shfmt',
                    'cpplint',
                    'clang-format',
                    'flake8',
                    'blue',
                },
            })

            require('neodev').setup({})

            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'bashls', 'clangd', 'pylsp' },
                handlers = {
                    function(server_name)
                        -- print('setting up ', server_name)
                        -- lazy load this stuff
                        require('lspconfig')['lua_ls'].setup({
                            -- settings = {
                            --     Lua = {
                            --         diagnostics = { globals = { 'vim' } },
                            --         runtime = {
                            --             -- version = 'LuaJIT',
                            --         },
                            --     },
                            -- },
                        })
                        require('lspconfig')['bashls'].setup({
                            -- vim.api.nvim_create_autocmd('FileType', {
                            --     pattern = 'sh',
                            --     callback = function()
                            --         vim.lsp.start({
                            --             name = 'bash-language-server',
                            --             cmd = { 'bash-language-server', 'start' },
                            --         })
                            --     end,
                            -- }),
                        })
                        require('lspconfig')['clangd'].setup({
                            -- vim.api.nvim_create_autocmd('FileType', {
                            --     pattern = 'sh',
                            --     callback = function()
                            --         vim.lsp.start({
                            --             name = 'bash-language-server',
                            --             cmd = { 'bash-language-server', 'start' },
                            --         })
                            --     end,
                            -- }),
                        })
                        require('lspconfig')['pylsp'].setup({
                            -- settings = {
                            --     pylsp = {
                            --         pyflakes = { enabled = false },
                            --         pylint = { enabled = false },
                            --         pycodestyle = { enabled = 'false' },
                            --         flake8 = { enabled = 'false' },
                            --     },
                            -- },
                        })
                    end,
                },
            })

            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),

                    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'path', keyword_length = 0 },
                    { name = 'luasnip' },
                }, { { name = 'buffer' } }),
            })
        end,
    },
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lint = require('lint')

            lint.linters_by_ft = {
                lua = { 'luacheck' },
                sh = { 'shellcheck' },
                c = { 'cpplint' },
                cpp = { 'cpplint' },
                python = { 'flake8' },
            }

            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

            vim.api.nvim_create_autocmd({
                'BufEnter',
                'BufWritePost',
                'InsertLeave',
            }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })

            vim.keymap.set('n', '<leader>L', function()
                lint.try_lint()
            end, { desc = 'Trigger linting for current file' })
        end,
    },
    {
        'stevearc/conform.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local conform = require('conform')

            conform.setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    sh = { 'shfmt' },
                    c = { 'clang-format' },
                    cpp = { 'clang-format' },
                    -- python = { "isort", "black" },
                    python = { 'blue' },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                },
            })

            vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    -- timeout_ms = 500
                })
            end, { desc = 'Format file or range (in visual mode)' })
        end,
    },
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
    {
        'fladson/vim-kitty',
        event = { 'BufReadPre', 'BufNewFile' },
    },
    -- this one is a bit shady
    { 'kovetskiy/sxhkd-vim', event = { 'BufReadPre', 'BufNewFile' } },
})
