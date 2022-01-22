-- Install Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Run PackerCompile whenever we save on init.lua
vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

-- Setup plugins
local use = require('packer').use
require('packer').startup(function()
  -- Package manager
  use 'wbthomason/packer.nvim'
  -- File explorer
  use 'preservim/nerdtree'
  -- Resize any window/pane
  use 'simeji/winresizer'
  -- Make it easy to comment visual regions/lines
  use 'tpope/vim-commentary'
  -- Setup FZF to search for things
  use { 'junegunn/fzf', dir = '~/.fzf', run = ':call fzf#install()' }
  use 'junegunn/fzf.vim'
  -- Colorscheme
  use 'dracula/vim'
  -- Fancier statusline
  use 'itchyny/lightline.vim'
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'
  -- Autocompletion with snippets support
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  -- Make code action easier to use
  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })
  --
end)

-- General Settings
vim.opt.hlsearch = true                     -- Highlight search
vim.opt.incsearch = true                    -- Increment search
vim.opt.autoindent = true                   -- Always set autoindenting on
vim.opt.copyindent = true                   -- Copy the previous indentation on autoindenting
vim.opt.number = true                       -- Always show line numbers
vim.opt.shiftwidth = 2                      -- Number of spaces to use for autoindenting
vim.opt.shiftround = true                   -- Use multiple of shiftwidth when indenting with '<' and '>'
vim.opt.showmatch = true                    -- Set show matching parenthesis
vim.opt.ignorecase = true                   -- Ignore case when searching
vim.opt.smartcase = true                    -- Ignore case if search pattern is all lowercase, case-sensitive otherwise
vim.opt.smarttab = true                     -- Insert tabs on the start of a line according to shiftwidth, not tabstop
vim.opt.expandtab = true                    -- Tab key inserts spaces
vim.opt.tabstop = 4                         -- Tab size is 4 spaces
vim.opt.smartindent = true                  -- Use smart indentation
vim.opt.backspace = 'indent,eol,start'      -- More natural backspace
vim.opt.laststatus = 2                      -- Always show the status line
vim.opt.showtabline = 2                     -- Always show the tabline
vim.opt.hidden = true                       -- Hides the buffer instead of closing them
vim.opt.history = 1000                      -- Remember more commands and search history
vim.opt.undolevels = 1000                   -- Use many levels of undo
vim.opt.scrolloff = 5                       -- Keep the cursor to have 5 lines of context
vim.opt.autochdir = false                   -- Do not change the current work directory automatically
vim.opt.splitright = true                   -- Open split pane on the right
vim.opt.mouse = 'a'                         -- Enable mouse mode
vim.opt.breakindent = true                  -- Enable break indent
vim.opt.undofile = true                     -- Save undo history across sessions
vim.opt.swapfile = false                    -- Disable .swp file creation
vim.opt.backup = false                      -- Disable backup file creation
vim.opt.signcolumn = 'yes'                  -- Always show sign column
vim.opt.completeopt = 'menuone,noselect'    -- Set completeopt to have a better completion experience

-- Toggle whitespace chars to make them more obvious
vim.opt.listchars = 'eol:$,tab:->,trail:~,extends:>,precedes:<'
vim.api.nvim_set_keymap('n', '<leader>ws', ':set list!<CR>', { noremap = true, silent = true })

-- Use both Unix and DOS file formats, but favor the Unix one for new files.
vim.opt.fileformats = 'unix,dos'
vim.opt.ff = 'unix'

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.dracula_terminal_italics = 2
vim.cmd [[colorscheme dracula]]

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Move around the windows easily
vim.api.nvim_set_keymap('', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- On save, remove all trailing whitespace
vim.cmd [[
  augroup TrimOnSave
    autocmd BufWritePre * %s/\s\+$//e
  augroup end
]]

-- Remap j/k for dealing with word wrap to move vertically
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Use ctrl-c to close quickfix window or location list window
vim.api.nvim_set_keymap('n', '<C-c>', ':cclose<CR> :lclose<CR>', { noremap = true, silent = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Dim inactive panes (neovim only)
vim.cmd[[
  hi ActiveWindow ctermbg=16 | hi InactiveWindow guibg=#474747
  set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
]]

-- ALWAYS use the clipboard for ALL operations (instead of interacting with
-- the '+' and/or '*' registers explicitly)
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- Start/enter terminal in insert mode always
vim.cmd [[
    autocmd TermOpen term://* setlocal nonumber
    autocmd TermOpen term://* startinsert
    autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
]]

-- Use ctrl-t to open new tab
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true})

-- For terminal, 'wrap' option is disabled by default. Re-enable it.
vim.cmd [[
  augroup WrapOnTermOpen
    autocmd TermOpen * setlocal wrap
  augroup end
]]

-- Open terminal in new tab
vim.api.nvim_set_keymap('n', '<leader>t',
  ':tabnew<BAR>:terminal "C:\\Program Files\\Git\\bin\\bash.exe" --login -i<CR>',
  { noremap = true, silent = true })

-- Remap escape key to go back to normal mode when inside terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Tabs navigation
local tab_nav_keymap = function(key, action)
  local n_opts = { noremap = true, silent = true }
  local t_opts = { noremap = false, silent = true }
  vim.api.nvim_set_keymap('n', key, action, n_opts)
  vim.api.nvim_set_keymap('t', key, '<Esc>' .. action, t_opts)
end
tab_nav_keymap('<C-Left>', ':tabprevious<CR>')
tab_nav_keymap('<C-Right>', ':tabnext<CR>')
for i = 1,9 do
  -- map ctrl-1 to ctrl-9 for quick tab1 to tab9 access
  tab_nav_keymap('<C-' .. i .. '>', i .. 'gt')
end

-- Configure nerdtree sidebar
vim.api.nvim_set_keymap('n', '<leader><leader>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':NERDTreeFind<CR>', { noremap = true, silent = true })

-- Show full file path in status bar
vim.g.lightline = {
  colorscheme = 'dracula',
  active = { left = { { 'mode', 'paste' }, { 'readonly', 'absolutepath', 'modified' } } },
}

-- Use ctrl-/ to toggle comments
vim.api.nvim_set_keymap('n', '<C-/>', ':Commentary<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-/>', ':Commentary<CR>', { noremap = true, silent = true })

-- Show indent blankline, except for a few places.
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Configure FZF to find things
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-space>', ':History<CR>', { noremap = true, silent = true })

-- LSP settings
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-Enter>', '<cmd>:CodeActionMenu<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  -- format on save. use the _sync() version to avoid buffer being messed up.
  vim.cmd [[
    augroup FormatOnSave
      autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
    augroup end
  ]]
end

-- Enable the following language servers
local servers = { 'gopls', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Use luasnip as additional autocomplete source
local luasnip = require 'luasnip'

-- Use nvim-cmp to support additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use nvim-cmp for autocomplete
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Load any overrides if available
pcall(require, 'local-overrides')
