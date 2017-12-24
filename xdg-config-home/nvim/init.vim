" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'tag': 'v1.13' }
Plug 'alvan/vim-closetag'
Plug 'danro/rename.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mileszs/ack.vim'
Plug 'rust-lang/rust.vim'

" Theming
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go'
Plug 'Shougo/echodoc.vim'

call plug#end()

" Configure langclient
let g:LanguageClient_serverCommands = {
	\ 'python': ['pyls'],
	\ 'rust': ['rls'],
	\}
let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI = "location-list"
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
command LCrename :call LanguageClient_textDocument_rename()<CR>
command LCrefs :call LanguageClient_textDocument_references()<CR>

" Basic configuration
syntax on
set number
set scrolloff=10

" Set up The Silver Searcher
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

" Set up FZF
nnoremap <Leader>p :FZF<CR>

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
let g:netrw_list_hide='.*\.class$' " Have netrw hide class files

" Set up closetag
let g:closetag_filenames="*.html,*.xml"

" Shortcut for clearing find highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Folding configuration
set foldmethod=syntax
set foldlevelstart=99

" Theme configuration
if has("nvim") || has("gui_running")
    colorscheme solarized " Set colorscheme to solarized when true color should be available
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
