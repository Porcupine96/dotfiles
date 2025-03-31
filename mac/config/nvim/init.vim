set clipboard+=unnamedplus

call plug#begin()

Plug 'tpope/vim-surround'

"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

"Plug 'kiyoon/jupynium.nvim', { 'do': 'pip3 install --user .' }
"Plug 'hrsh7th/nvim-cmp'
"Plug 'rcarriga/nvim-notify'
"Plug 'stevearc/dressing.nvim'

call plug#end()


nnoremap <C-w>d <C-w>c

" Switch between panes using Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l