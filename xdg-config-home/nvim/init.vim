" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'tag': 'v1.12' }
Plug 'jodosha/vim-godebug'
Plug 'alvan/vim-closetag'
Plug 'danro/rename.vim'

" Theming
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'frankier/neovim-colors-solarized-truecolor-only'

" Autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go'
" Works great but slows down startup. Re-enable when working on Python.
Plug 'zchee/deoplete-jedi'

call plug#end()

# Set up PyLint support
autocmd FileType python set makeprg=pylint\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p
autocmd FileType python set errorformat=%f:%l:\ %m

" Basic configuration
syntax on
set number
set scrolloff=10

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

" Netrw configuration
let g:netrw_list_hide='.*\.class$' " Have netrw hide class files

" ctrlp.vim configuration
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(class|o)$',
            \ 'link': '',
            \ }
let g:ctrlp_max_files = 0
let g:ctrlp_working_path_mode = 'a'

" Set up closetag
let g:closetag_filenames="*.html,*.xml"

" Shortcut for clearing find highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Folding configuration
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
set background=light " Run the light solarized theme

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

" Configure gVim
if has('gui_running')
    " Remove gvim graphical elements
    set guioptions-=m
    set guioptions-=t
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
endif
