" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-vinegar'
Plug 'danro/rename.vim'
Plug 'reaysawa/auto-pairs'

" Theming
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'icymind/NeoSolarized'

" React and Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

call plug#end()

" Turn off guicursor in terminal
set guicursor=

" Basic configuration
syntax on
set number
set scrolloff=10

" Set up Ack
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

" Always trust changes on disk
set autoread

" Filetype-specific settings
filetype plugin on

" Setup a special escape sequence
inoremap jk <esc>

" Disable scratch window when using omnicomplete
set completeopt-=preview

" Set up leader shortcuts
let mapleader = "\<Space>"
nnoremap <Leader>q :q<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>w <C-w>
nnoremap <Leader>f :Ack!<Space>
nnoremap <Leader>p :Denite file/rec -start-filter<CR>
nnoremap <Leader>b :Denite buffer -start-filter<CR>

" Arrow keys for fast scrolling
nnoremap <Up> 10k
nnoremap <C-k> 10k
nnoremap <Down> 10j
nnoremap <C-j> 10j

set shortmess+=c " Makes Omnicomplete quiet in the status bar
set noshowmode

" Netrw configuration
let g:netrw_list_hide='.*\.class$,.*\.meta$' " Have netrw hide class files

" Set up closetag
let g:closetag_filenames="*.html,*.xml"

" Shortcut for clearing find highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Folding configuration
set foldmethod=syntax
set foldlevelstart=99

" Theme configuration
if has("nvim") || has("gui_running")
    colorscheme NeoSolarized " Set colorscheme to solarized when true color should be available
else
    colorscheme desert " Set colorscheme to something sane in case I need to use vim
end
set background=dark

" Neovim terminal configuration
if has("nvim")
    tnoremap <Esc> <C-\><C-n> " Exits the terminal
end

" LaTeX configuration
let g:tex_flavor='latex'

" Multi-file configuration
set hidden

" Airline configuration
set laststatus=2 " Turn on the status bar at all times

" Enable spellcheck
set spell spelllang=en_us

set termguicolors
