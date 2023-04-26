" --- Keymaps ---

noremap <Space> <Nop>
let mapleader = " "

inoremap jk <Esc>                   " exit insert mode
noremap <leader>q :q<CR>            " quit
noremap <leader>s :w<CR>            " save
inoremap <C-h> <left>               " move in insert
inoremap <C-l> <right>              " move in insert
inoremap {<cr> {<cr>}<c-o>O<Tab>    " auto braces
inoremap (<cr> ()<c-o>i             " auto parenthesis
nnoremap Y y$                       " copy until end of line

vnoremap <leader>y "*y              " Copy to clipboard
xnoremap p [["_dp]]                 " Dont ovveride when pasting

" Window
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <S-Up> :resize +2<CR>
nnoremap <S-Down> :resize -2<CR>
nnoremap <S-Left> :vertical resize -2<CR>
nnoremap <S-Right> :vertical resize +2<CR>

" Files
noremap <leader>e :Ex<CR>           " enter file navigation
let g:netrw_liststyle = 3
let g:netrw_banner = 0
function! SetupNetrw()
    nmap <buffer> l <CR> 
endfunction
autocmd FileType netrw call SetupNetrw()
" autocmd FileType netrw nmap <buffer> <Space> <CR>

" Tabbing
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" --- Options ---
set number
set relativenumber
set nohlsearch
set hidden
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set incsearch
set nowrap
set scrolloff=8
set splitbelow
set splitright
" set termguicolors
set ignorecase
set timeoutlen=200
set updatetime=300

set noswapfile
set nobackup

syntax on
