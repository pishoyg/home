---@diagnostic disable: missing-fields
-- Load user-installed installed Lua rocks:
local rocks = vim.fn.expand("$HOME" .. "/.luarocks/share/lua/5.1/?")
package.path = package.path .. ";" .. rocks .. "/init.lua;"
package.path = package.path .. ";" .. rocks .. ".lua;"

-- Plugin Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

-- Set of shortcuts
local opt = vim.opt        -- set options
local wopt = vim.wo
local key = vim.keymap.set -- set keymap
local edit = vim.g         -- set editor variables
local exec = vim.cmd

-- Options
opt.rtp:prepend(lazypath) -- Plugin Manager
opt.tabstop = 2
opt.softtabstop = 2       -- Number of spaces that a <Tab> counts for
opt.textwidth = 79
opt.shiftwidth = 2        -- Size of an indent
opt.expandtab = true      -- Use spaces instead of tabs
opt.colorcolumn = '80'
opt.spell = true
opt.relativenumber = true -- Show relative line numbers
opt.autochdir = true
opt.hlsearch = false          -- Set highlight on search
opt.mouse = 'a'               -- Enable mouse mode
opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
opt.breakindent = true        -- Enable break indent
opt.undofile = true           -- Save undo history
opt.wrap = false
opt.wrapmargin = 2
opt.ignorecase = true -- Case insensitive searching UNLESS \C or capital in search
opt.smartcase = true
opt.updatetime = 250  -- Decrease update time
opt.timeout = true
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect' -- complete options
opt.termguicolors = true             -- Colors
opt.foldcolumn = '0'                 -- Where to fold
opt.foldlevel = 99                   -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
-- Window Options
wopt.number = true      -- Make line numbers default
wopt.signcolumn = 'yes' -- Keep signcolumn on by default

-- editor variables
edit.mapleader = ' '
edit.maplocalleader = ' '

-- Install Plugins
require('lazy').setup({

  { -- Jupyter Notebooks
    'dccsillag/magma-nvim',
  },

  -- {
  --   "homerours/jumper.nvim",
  --   dependencies = {
  --     'ibhagwan/fzf-lua'                 -- alternatively, for fzf-lua backend
  --   },
  --   config = function()
  --     local jumper = require("jumper.fzf-lua")

  --     -- Configure bindings to launch the pickers:
  --     vim.keymap.set('n', '<c-y>', jumper.jump_to_directory)
  --     vim.keymap.set('n', '<c-u>', jumper.jump_to_file)
  --     vim.keymap.set('n', '<leader>fu', jumper.find_in_files)
  --   end
  -- },

  {
    'AckslD/swenv.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          require('swenv.api').pick_venv()
        end
      })
    end,
  },

  { -- multiple independent Plugins
    'echasnovski/mini.nvim',
    version = '*',
    init = function()
      require('mini.comment').setup()
    end
  },

  { -- edit directories and files like buffers
    "stevearc/oil.nvim",
    init = function()
      require("oil").setup()
    end
  },

  { -- Folding
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      require('ufo').setup({
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end
      })
    end,

    lazy = true,
  },

  {
    'josa42/nvim-gx'
  },

  {                           -- Preview markdown code directly in your neovim terminal
    "MeanderingProgrammer/markdown.nvim",
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup({})
    end,
  },

  { --
    'folke/noice.nvim',
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper module="..." entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   nvim-notify is only needed, if you want to use the notification view.
      --   If not available, we use mini as the fallback
      "rcarriga/nvim-notify",
    }
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      key('', '<Esc>', "<ESC>:noh<CR>:lua require('notify').dismiss()<CR>", { silent = true })
    end
  },

  {
    'nvim-focus/focus.nvim',
  },

  { -- prettier
    "MunifTanjim/prettier.nvim"
  },

  { -- LSP related
    "jose-elias-alvarez/null-ls.nvim"
  },

  { -- Help with typst
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false
  },

  { -- show variable types
    'jubnzv/virtual-types.nvim',
    lazy = true
  },

  { -- show function signature
    'ray-x/lsp_signature.nvim',
    lazy = true
  },

  { -- copilot-cmp
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  { -- Terminal in neovim
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
    opts = {
      insert_mappings = true,
    },
  },

  { -- Markdown
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      edit.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true },
        panel = { enabled = false },
        filetypes = { markdown = true },
      })
    end,
    lazy = true,
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    opts = {}
  },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See :help gitsigns.txt
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    init = function()
      require("catppuccin").setup()
      -- Set Theme
      if os.getenv('ITERM_PROFILE') == 'Dark' then
        exec([[colorscheme catppuccin-macchiato]])
      else
        exec([[colorscheme catppuccin-macchiato]])
        exec([[colorscheme catppuccin-latte]])
      end
    end
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See :help lualine.txt
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
    sections = {
      lualine_a = { 'buffer', },
      lualine_b = { 'progress', }
    },

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    }
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    init = function()
      require("ibl").setup()
    end
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if make is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- config = function()
    --   pcall(require('nvim-treesitter.install').update { with_sync = true })
    -- end,
  },
}, {})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {
  clear = true
})
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See :help telescope and :help telescope.setup()
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Configure Treesitter
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c',
    'cpp',
    'go',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'vimdoc',
    'vim'
  },
  sync_install = true,
  ignore_install = {}, -- List of parsers to ignore installing
  modules = {},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

require("focus").setup()

require("noice").setup({
  lsp = {
    -- override markdown rendering so that cmp and other plugins use Treesitter
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    signature = {
      enabled = false,
    }
  },
})

-- Key maps
key('n', 'zR', require('ufo').openAllFolds)
key('n', 'zM', require('ufo').closeAllFolds)
key('n', '<C-j>', [[:ToggleTerm<CR><C-\><C-n>i]], {
  silent = true,
  desc = 'Toggle terminal'
})                                               -- Open terminal `
key('t', '<C-j>', [[<C-\><C-n>:ToggleTerm<CR>]]) -- close terminal
key('t', '<C-w>', [[<C-\><C-n><C-w>]])           -- move between windows when in terminal
key('n', 'gx', require('gx').gx)                 -- GX
key('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
key('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
key('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
key('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
key({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- Leader
-- Remap for dealing with word wrap
key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Set of Telescope Key maps
key('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
key('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
key('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
key('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
key('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
key('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
key('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
key('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- LSP keymaps and settings
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    key('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See :help K for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command :Format local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- LSP setup
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}
require('mason-lspconfig').setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
  ['verible'] = function()
    require('lspconfig').verible.setup {
      cmd = { 'verible-verilog-ls', '--rules_config_search' },
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
  ['clangd'] = function()
    require("lspconfig").clangd.setup {
      cmd = {
        "/usr/bin/clangd",
        "--offset-encoding=utf-16",
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}
require 'lsp_signature'.setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  },
  select_signature_key = "<C-s>",
  toggle_key = "<C-h>",
})

-- Snippets
local ls = require 'luasnip'
ls.config.setup {}
ls.config.set_config({
  history = true,                            -- keep last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", -- Update while typing in insert mode
  enable_autosnippets = true,                -- use autosnippets
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { "choiceNode", "Comment" } },
      },
    }
  }
})

require("luasnip.loaders.from_lua").load({
  paths = {
    "~/.config/nvim/snippets/"
  }
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "Format C/C++/Verilog on save",
  pattern = { ".c", ".h", ".cpp", ".hpp", ".cc", ".hh", "*.v" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Completion
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.complete {},
    ['<C-i>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if ls.expand_or_locally_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if ls.locally_jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sorting = {
    priority_weight = 1,
    comparators = {
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.order,
    },
  },
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = "path" },
    { name = 'buffer' },
  })
}
