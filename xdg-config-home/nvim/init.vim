" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go', { 'tag': 'v1.10' }
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'alvan/vim-closetag'
Plug 'danro/rename.vim'

call plug#end()

" Filetype-specific settings
filetype plugin on

syntax on

" Setup a special escape sequence
inoremap jk <esc>

" Set up my leader, space
let mapleader = "\<Space>"

" Disable scratch window when using omnicomplete
set completeopt-=preview

" Set up leader shortcuts
nnoremap <Leader>q :q<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>gb :GoBuild<CR>
nnoremap <Leader>w <C-w>

" Arrow keys for fast scrolling
nnoremap <Up> 10k
nnoremap <C-k> 10k
nnoremap <Down> 10j
nnoremap <C-j> 10j

" Turn off Python linting on save
let g:pymode_lint_write = 0
let g:pymode_lint = 0

" Netrw configuration
let g:netrw_list_hide='.*\.class$' " Have netrw hide class files

" Set up closetag
let g:closetag_filenames="*.html,*.xml"

" Shortcut for clearing find highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Turn on line numbers
"set relativenumber
set number

" Always allow a few lines before or after the cursor
set scrolloff=10

" Folding configuration. Has the double effect of having one layer of folding
" by default.
set foldmethod=syntax
set foldlevelstart=99

" Theme configuration
if has("nvim")
	set termguicolors
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " Enable true color by default
endif
if has("nvim") || has("gui_running")
	colorscheme solarized " Set colorscheme to solarized when true color should be available
else
	colorscheme desert " Set colorscheme to something sane in case I need to use vim
end
set background=dark " Run the dark solarized theme

" Neovim terminal configuration
if has("nvim")
	tnoremap <Esc> <C-\><C-n> " Exits the terminal
end

" LaTeX configuration
let g:tex_flavor='latex'

" Multi-file configuration
set hidden

" Tagbar configuration
nmap tb :TagbarToggle<CR>

" Airline configuration
set laststatus=2 " Turn on the status bar at all times

" vim-go configuration
let g:go_fmt_command = "goimports"

" Configure gVim
if has('gui_running')
	" Remove gvim graphical elements
	set guioptions-=m
	set guioptions-=t
	set guioptions-=T
	set guioptions-=L
	set guioptions-=r
endif
