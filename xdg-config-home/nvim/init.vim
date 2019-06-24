" Start vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'danro/rename.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mileszs/ack.vim'
Plug 'LnL7/vim-nix'
Plug 'reaysawa/auto-pairs'

" Denite
Plug 'Shougo/denite.nvim', {'tag': '*', 'do': ':UpdateRemotePlugins'}

" Theming
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'icymind/NeoSolarized'

" Autocomplete
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" React and Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

call plug#end()

autocmd BufReadPost *.rs setlocal filetype=rust

" Prettier configuration
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

call plug#end()

" coc.nvim configuration
" Run goimports on save for Go files
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
" Map various cool Coc functionality
autocmd FileType go nmap <silent> gd <Plug>(coc-definition)
autocmd FileType go nmap <silent> gr <Plug>(coc-references)
autocmd FileType go nnoremap <silent> K :call CocAction('doHover')
autocmd FileType go nmap <Leader>rn <Plug>(coc-rename)
autocmd FileType go nnoremap <Leader>d :CocList diagnostics<CR>

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
"let g:deoplete#enable_at_startup = 1
"call g:deoplete#custom#option('omni_patterns', {'go': '[^. *\t]\.\w*'})
"inoremap <silent> <CR> <C-r>=<SID>smart_cr()<CR>
"function! s:smart_cr()
	"return deoplete#mappings#smart_close_popup() . "\<CR>"
"endfunction
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
let g:go_def_mode='gopls'

" Enable spellcheck
set spell spelllang=en_us
