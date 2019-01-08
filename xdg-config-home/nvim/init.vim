" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'tag': 'v1.19' }
Plug 'alvan/vim-closetag'
Plug 'danro/rename.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mileszs/ack.vim'
Plug 'rust-lang/rust.vim'
Plug 'LnL7/vim-nix'
Plug 'alfredodeza/pytest.vim'
Plug 'reaysawa/auto-pairs'

" Denite
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" Theming
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'icymind/NeoSolarized'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go'
Plug 'Shougo/echodoc.vim'

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
nnoremap <Leader>gb :GoBuild<CR>
nnoremap <Leader>w <C-w>
nnoremap <Leader>f :Ack!<Space>
nnoremap <Leader>p :Denite file_rec<CR>
nnoremap <Leader>b :Denite buffer<CR>
nnoremap <Leader>d :Denite decls<CR>

" Set up Denite
call denite#custom#map(
    \ 'insert',
    \ '<Down>',
    \ '<denite:move_to_next_line>',
    \ 'noremap')
call denite#custom#map(
    \ 'insert',
    \ '<Up>',
    \ '<denite:move_to_previous_line>',
    \ 'noremap')
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min*', 'img/', 'fonts/'])

" Arrow keys for fast scrolling
nnoremap <Up> 10k
nnoremap <C-k> 10k
nnoremap <Down> 10j
nnoremap <C-j> 10j

" Deoplete setup
let g:deoplete#enable_at_startup = 1
let g:deoplete#complete_method = "omnifunc"
inoremap <silent> <CR> <C-r>=<SID>smart_cr()<CR>
function! s:smart_cr()
	return deoplete#mappings#smart_close_popup() . "\<CR>"
endfunction
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

" vim-go configuration
let g:go_fmt_command = "goimports" " Run goimports on save
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Enable spellcheck
set spell spelllang=en_us
