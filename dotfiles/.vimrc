syntax on

set autoindent
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

set ignorecase
set smartcase
set incsearch
set hlsearch

set nohidden
nnoremap <silent> <C-j> <C-W>w
nnoremap <silent> <C-k> <C-W>W
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-d> :quit<CR>
nnoremap <silent> <C-n> :cn<CR>
nnoremap <silent> <C-b> :cp<CR>
nnoremap \s :split<Space>
nnoremap \t :tabnew<Space>
