-- Load stuff
vim.g.python3_host_prog = '/usr/bin/python'
vim.g.ruby_host_prog =
'/home/sean/.local/share/gem/ruby/3.0.0/bin/neovim-ruby-host'
vim.g.node_host_prog = '/usr/bin/neovim-node-host'
vim.g.loaded_perl_provider = 0

-- Options

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.showmode = false

vim.opt.smartindent = true
vim.opt.expandtab = true

-- vim.opt.numberwidth = ?

vim.opt.number = true
vim.opt.relativenumber = true

-- Line wrap
vim.opt.wrap = false

vim.opt.mouse = 'a'
vim.opt.mousefocus = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.timeoutlen = 100
-- vim.opt.timeoutlen = 500

-- works when pushed down to end of init.lua ??
-- vim.opt.laststatus = 3
-- vim.cmd[[highlight Comment gui=italic]]

-- vim.env.XXXX will access enviornment variables!!

-- Keymaps

vim.g.mapleader = ' '
vim.g.maplocalleader = ',' -- what does this do?

-- local opts = { noremap = true, silent = true }
local opts = { noremap = true }

vim.keymap.set('n', '<leader>q', '<cmd>q!<cr>')
vim.keymap.set('n', '<leader>w', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>update<cr><cmd>q<cr>')
vim.keymap.set('n', 'Q', 'q', opts)
vim.keymap.set('n', 'q', '<Nop>')
vim.keymap.set('n', '<leader>h', ':vert help ')
vim.keymap.set('n', '<F4>', '<cmd>w<cr><cmd>luafile %<cr>')
vim.keymap.set('n', '<leader>t', '<cmd>tabNext<cr>')
vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('v', ';', ':', opts)

-- Window navigation

vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
vim.keymap.set('n', '<left>', '<C-w>h', opts)
vim.keymap.set('n', '<down>', '<C-w>j', opts)
vim.keymap.set('n', '<up>', '<C-w>k', opts)
vim.keymap.set('n', '<right>', '<C-w>l', opts)

-- learn the lua version of this "au" will be useful
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

-- Clipboard      work required here

vim.opt.clipboard = 'unnamedplus' -- not sure that this is actually working...

vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-v>', '"+p') -- didnt work with 'i' set might be working now ? normal mode

-- Packer

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

local packer = require('packer')

packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  },
  enable = true,
  threshold = 0
})

local use = packer.use
packer.reset()

use('wbthomason/packer.nvim')

-- Colorscheme

use('Mofiqul/dracula.nvim')

use('rebelot/kanagawa.nvim')

use 'ishan9299/modus-theme-vim'

use({ 'catppuccin/nvim', as = 'catppuccin' })

-- local present, catppuccin = pcall(require, 'catppuccin')
-- if not present then return end

vim.api.nvim_command(({
  -- alacritty = 'colorscheme dracula',
  alacritty = 'colorscheme catppuccin',
  -- foot = 'colorscheme catppuccin'
  foot = 'colorscheme modus-vivendi'
})[vim.env.TERM] or 'colorscheme kanagawa')
-- })[vim.env.TERM] or 'colorscheme modus-vivendi')

-- Tree

use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons' -- optional, for file icons
  },
  tag = 'nightly' -- optional, updated every week. (see issue #1193)
}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require('nvim-tree').setup()

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- Lualine

use({
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
})

require('lualine').setup({
  options = {
    -- theme = 'catppuccin',
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' }
  },
  sections = {
    lualine_c = {},
    lualine_x = { 'filetype' },
    lualine_z = { 'filename' }
  }
})

-- Bufferline

use {
  'akinsho/bufferline.nvim',
  tag = 'v3.*',
  requires = 'nvim-tree/nvim-web-devicons'
}

require('bufferline').setup {
  options = {
    -- mode = 'tabs',     -- set to buffers but worth looking into tabs seem easier
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        text_align = 'center',
        separator = true
      }
    },
    always_show_bufferline = false,
    separator_style = 'slant'
  }
}

vim.keymap.set('n', '<leader>b', '<cmd>BufferLineCycleNext<cr>')
vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<cr>')

-- Colorizer

use('norcalli/nvim-colorizer.lua')

require('colorizer').setup()

-- Surrounded

-- example cs'" means change surrounding ' to "

use({
  'kylechui/nvim-surround',
  tag = '*', -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    require('nvim-surround').setup({
      -- Configuration here, or leave empty to use defaults
    })
  end
})

-- Which-key

use('folke/which-key.nvim')

require('which-key').setup()

-- Autopairs

use({
  'windwp/nvim-autopairs'
  -- config = function() require('nvim-autopairs').setup({}) end
})

require('nvim-autopairs').setup({ enable_check_bracket_line = false })

-- Treesitter

use({
  'nvim-treesitter/nvim-treesitter',
  run = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end
})

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  -- indent = {enable = true},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm'
    }
  }
})

-- Comment

use('numToStr/Comment.nvim')

require('Comment').setup()

-- Telescope

use({ 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } })
use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
use({ 'nvim-telescope/telescope-file-browser.nvim' })
use({ 'nvim-telescope/telescope-media-files.nvim' }) -- only working with Xorg because of ueberzug
use({ 'xiyaowong/telescope-emoji.nvim' })

-- telescope wasnt using these icons until i added the line below
use('nvim-tree/nvim-web-devicons') -- also used in lualine... where and when to require it?...

use({
  'AckslD/nvim-neoclip.lua',
  requires = {
    { 'kkharji/sqlite.lua', module = 'sqlite' },
    -- you'll need at least one of these
    { 'nvim-telescope/telescope.nvim' }
    -- {'ibhagwan/fzf-lua'},
  }
  -- config = function()
  --   require('neoclip').setup()
  -- end,
})

-- used in example in mappings with ['<C-a>']
local action_state = require('telescope.actions.state')

require('telescope').setup({
  defaults = {
    prompt_prefix = '🔭 ',
    -- file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    -- color_devicons = true, hmmm get this working
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ['<C-h>'] = 'which_key',
        -- example ...
        ['<C-a>'] = function()
          print(vim.inspect(action_state.get_selected_entry()))
        end
        -- ['<C-v>'] will open in a vertial split by default
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('media_files') -- cool idea but not working with wayland?... look into it
require('telescope').load_extension('emoji')
-- require('neoclip').setup()
require('telescope').load_extension('neoclip')

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
-- vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>')

vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
-- vim.keymap.set("n", "<leader>/", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({sorting_stategy='ascending'})<cr>")

vim.keymap.set('n', '<leader>fb', '<cmd>Telescope file_browser<cr>',
  { noremap = true }) -- whats going on with this noremap thing??
vim.keymap.set('n', '<leader>fe', '<cmd>Telescope emoji<cr>', { noremap = true }) -- whats going on with this noremap thing??

vim.keymap
    .set('n', '<leader>fc', '<cmd>Telescope neoclip<cr>', { noremap = true }) -- whats going on with this noremap thing??

-- LSP

use('neovim/nvim-lspconfig')

local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach()
  -- print('lsp attached to buffer')
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
end

-- lsp.sumneko_lua.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   settings = { Lua = { diagnostics = { globals = { 'vim', 'awesome' } } } }
-- })

lsp.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { Lua = { diagnostics = { globals = { 'vim', 'awesome' } } } }
})

-- lsp.pyright.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   settings = {}
-- })
--

lsp.pylsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})


lsp.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})

lsp.clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})

lsp.solargraph.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})

lsp.julials.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})

lsp.zls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
})

-- Rust

use 'simrat39/rust-tools.nvim'

local rt = require('rust-tools')

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions,
        { buffer = bufnr })
      -- Code action groups
      vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group,
        { buffer = bufnr })
    end
  }
})

-- Haskell

lsp.dhall_lsp_server.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {}
}

-- Completion

use('hrsh7th/cmp-nvim-lsp')
use('hrsh7th/cmp-nvim-lua')
use('hrsh7th/cmp-buffer')
use('hrsh7th/cmp-path')
use('hrsh7th/cmp-cmdline')
-- use("hrsh7th/nvim-cmp")
-- \alpha<TAB> stuff for julia, works for only julia i think
use({
  'hrsh7th/nvim-cmp',
  requires = { { 'kdheepak/cmp-latex-symbols' } },
  sources = { { name = 'latex_symbols' }, { name = 'emoji' } }
})

use('onsails/lspkind.nvim') -- does it work without this line?? try it...

-- For luasnip users.
use('L3MON4D3/LuaSnip')
use('saadparwaiz1/cmp_luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local lspkind = require('lspkind')
lspkind.init()

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lua', keyword_length = 3 }, -- , max_item_count = ?, priority = ? },
    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'path', keyword_length = 3 }, { name = 'luasnip', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 }
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[api]',
        path = '[path]',
        luasnip = '[snip]'
      }
    })
  },
  experimental = { native_menu = false, ghost_text = true }
})

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- -- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }

-- Null-ls

use({
  'jose-elias-alvarez/null-ls.nvim',
  config = function() require('null-ls').setup() end,
  requires = { 'nvim-lua/plenary.nvim' }
})

local null = require('null-ls')

null.setup({
  sources = {
    -- Lua
    -- null.builtins.formatting.stylua,
    null.builtins.formatting.lua_format, -- this one seems to actually read the .config/luaformat/config.yaml
    -- null.builtins.diagnostics.luacheck,
    -- null.builtins.diagnostics.selene,

    -- Python
    -- null.builtins.formatting.black, 
    null.builtins.formatting.blue, 
    null.builtins.diagnostics.flake8,
    -- null.builtins.diagnostics.flake8.with {
    --     extra_args = {
    --         '--max-line-length 100'
    --     }
    -- },

    -- Javascript
    null.builtins.formatting.prettier,
    -- null.builtins.formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote' }}),
    -- null.builtins.diagnostics.jshint,
    null.builtins.diagnostics.eslint, -- C, C++
    null.builtins.formatting.clang_format,
    null.builtins.diagnostics.clang_check, -- Ruby
    null.builtins.formatting.rubocop, null.builtins.diagnostics.rubocop, -- Zig
    -- null.builtins.formatting.zigfmt,  seems to work without this line??
    -- Julia ? doesnt seem to be supported by null-ls?...
    -- Toml
    null.builtins.formatting.dprint, -- not sure this is working
    -- Haskell
    null.builtins.formatting.brittany, -- Fish
    null.builtins.diagnostics.fish, null.builtins.formatting.fish_indent
    -- null.builtins.completion.spell,
  }
})

vim.keymap.set('n', '<leader>F', '<cmd>lua vim.lsp.buf.format()<cr>')
-- TODO format on save

-- Impatient

use 'lewis6991/impatient.nvim'

require('impatient').enable_profile()

-- Zen mode

use 'folke/zen-mode.nvim'

require('zen-mode').setup {
  window = {
    options = { signcolumn = 'no', number = false, relativenumber = false }
  }
}

vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>')

-- Kitty runner

use { 'jghauser/kitty-runner.nvim' }

require('kitty-runner').setup {}

-- require('kitty-runner').setup({
--   -- name of the kitty terminal:
--   runner_name = 'kitty-runner-' .. uuid,
--   -- kitty arguments when sending lines/command:
--   run_cmd = {'send-text', '--'},
--   -- kitty arguments when killing a runner:
--   kill_cmd = {'close-window'},
--   -- use default keymaps:
--   use_keymaps = true,
--   -- the port used to communicate with the kitty terminal:
--   kitty_port = 'unix:/tmp/kitty-' .. uuid
-- })

vim.api.nvim_create_user_command('Coderunner', function()
  local function coderunner(language)
    local terminal = ':!kitty --hold --class=code_runner fish --command'
    local output = '% | figlet | lolcat'
    return string.format('%s \'%s %s\'', terminal, language, output)
  end

  vim.api.nvim_command(({
    c = coderunner('c'),
    cpp = coderunner('c'),
    fish = coderunner('fish'),
    javascript = coderunner('node'),
    julia = coderunner('julia --startup-file=no'),
    lua = coderunner('lua'),
    python = coderunner('python'),
    ruby = coderunner('ruby'),
    rust = coderunner('rust'),
    zig = coderunner('zig run')
  })[vim.bo.filetype])
end, {})

vim.api.nvim_create_user_command('Testrunner', function()
  local function testrunner(language)
    local terminal = ':!kitty --hold --class=code_runner fish --command '
    return terminal .. language
  end

  vim.api.nvim_command(({
    -- c = testrunner('c'),
    -- cpp = testrunner('c'),
    -- fish = testrunner('fish'),
    -- javascript = testrunner('node'),
    julia = testrunner('"julia --startup-file=no runtests.jl"'),
    -- julia = testrunner('julie runtests.jl'),
    lua = testrunner('busted'),
    -- python = testrunner('pytest'),
    python = testrunner('"pytest --disable-warnings"'),
    -- ruby = testrunner('ruby'),
    rust = testrunner('"cargo test"'),
    -- zig = testrunner('zig run')
  })[vim.bo.filetype])
end, {})

vim.keymap.set('n', '<leader>C', '<cmd>update<cr><cmd>Coderunner<cr><cr>')
vim.keymap.set('n', '<leader>T', '<cmd>update<cr><cmd>Testrunner<cr><cr>')
vim.keymap.set('n', '<leader>K', '<cmd>!kitty --detach $PWD<cr><cr>')

-- needs to be late in the file to work
vim.opt.laststatus = 3
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<cr>')


-- should be able to do better than this 
-- local filetype = vim.bo.filetype
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
if vim.bo.filetype == 'lua' or vim.bo.filetype == 'javascript' then
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
end

-- Neovide 
vim.cmd([[let g:neovide_cursor_animation_length = 0.1]])
vim.cmd([[let g:neovide_cursor_vfx_mode = "railgun"]])

-- fix this
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nu = {
  install_info = {
    url = "https://github.com/nushell/tree-sitter-nu",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "nu",
}
