let mapleader = " "
set clipboard+=unnamedplus

call plug#begin()

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-surround'
Plug 'hat0uma/csvview.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'scalameta/nvim-metals'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'stevearc/conform.nvim'

call plug#end()

colorscheme dracula

autocmd FileType markdown setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr() foldlevel=99

lua require('csvview').setup()
lua require('telescope').setup()

lua << EOF
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
EOF
lua << EOF
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = { 'pyright' } })
vim.lsp.enable('pyright')
EOF

lua << EOF
local metals_config = require("metals").bare_config()
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
EOF

lua << EOF
local ok, cmp = pcall(require, 'cmp')
if ok then
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
  })
end
EOF

lua << EOF
local ok, configs = pcall(require, 'nvim-treesitter.configs')
if ok then
  configs.setup({
    ensure_installed = { 'python', 'markdown', 'markdown_inline' },
    highlight = { enable = true },
  })
end
EOF

lua << EOF
local ok, conform = pcall(require, 'conform')
if ok then
  conform.setup({
    formatters_by_ft = {
      python = { 'ruff_format' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end
EOF

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-s> <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <C-w>d <C-w>c
nnoremap K  <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap gi <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<cr>
nnoremap <leader>cr <cmd>source $MYVIMRC<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>gc <cmd>edit $MYVIMRC<cr>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <leader>yp <cmd>let @+ = expand('%:p')<cr>
