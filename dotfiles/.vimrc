syntax on

set autoindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

" Show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/

set ignorecase
set smartcase
set incsearch

set nohidden
nnoremap <silent> <C-j> <C-W>w
nnoremap <silent> <C-k> <C-W>W
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-d> :quit<CR>
nnoremap <silent> ]q :cn<CR>
nnoremap <silent> [q :cp<CR>
nnoremap <silent> <C-c> :Texplore<CR>
nnoremap <silent> <C-z> :split<CR>
