syntax on

set autoindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

set ignorecase
set smartcase
set incsearch

set nohidden
nnoremap <silent> <C-j> <C-W>w
nnoremap <silent> <C-k> <C-W>W
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-d> :quit<CR>
nnoremap <silent> <C-n> :cn<CR>
nnoremap <silent> <C-b> :cp<CR>
nnoremap <silent> <C-c> :tabnew<CR>
nnoremap <silent> <C-z> :split<CR>
