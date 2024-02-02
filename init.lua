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

vim.opt.wrap = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.netrw_banner = 0

-- copy handled by kitty "control-c"
-- "control-v" to paste
vim.opt.clipboard = 'unnamedplus'
-- seems i dont need anything else?? do i need registers?
vim.opt.mouse = 'a'
vim.opt.mousefocus = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- if vim.bo.filetype == 'lua' or vim.bo.filetype == 'javascript' then
--   vim.opt.shiftwidth = 2
--   vim.opt.tabstop = 2
-- end

vim.g.mapleader = ' '
vim.g.maplocalleader = ',' -- what is this?

local opts = {noremap = true}

vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('v', ';', ':', opts)

-- move lines, this is pretty nice
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', 'K', ':m \'>-2<CR>gv=gv')

vim.keymap.set('n', '<leader>q', '<cmd>q!<cr>')

-- whats going on here?
-- local autocmd = vim.api.nvim_create_autocmd
-- local yank_group = augroup("HighlightYank", {})
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- latest stable release
        lazypath
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
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight-night]])
        end
    }, {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        opts = {
            options = {
                theme = 'auto',
                component_separators = {left = '', right = ''},
                section_separators = {left = '', right = ''}
            }
        }
    }, {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                }
            }
        end
        -- opts = {
        --     highlight = {
        --         enable = true,
        --         additional_vim_regex_highlighting = false
        --     }
        -- }
    }, {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false
        -- config = function() require('Comment').setup() end
    }, {
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
        }
        -- config = function() require('which-key').setup() end
    }, {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {} -- this is equalent to setup({}) function
    }, {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        -- lazy = true,
        dependencies = {'nvim-lua/plenary.nvim'},
        cmd = 'Telescope',
        keys = {{'<leader>ff', '<cmd>Telescope find_files<cr>'}}
    }, {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {'lua_ls'},
                handlers = {
                    function(server_name)
                        print('setting up ', server_name)
                        require('lspconfig')[server_name].setup {}
                    end
                }
            })

            local cmp = require 'cmp'

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end
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
                    ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'}, {name = 'luasnip'} -- For luasnip users.
                }, {{name = 'buffer'}})
            })
        end
    }
})
