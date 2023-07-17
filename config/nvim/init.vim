set clipboard+=unnamedplus

call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'kiyoon/jupynium.nvim', { 'do': 'pip3 install --user .' }
Plug 'hrsh7th/nvim-cmp'
Plug 'rcarriga/nvim-notify'
Plug 'stevearc/dressing.nvim'

call plug#end()

let mapleader = " "

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
