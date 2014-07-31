syntax on
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
set nohidden
set autochdir

" Tab settings
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

" Smarter search
set ignorecase
set smartcase
set incsearch

" Bindings
nnoremap <silent> <C-j> <C-W>w
nnoremap <silent> <C-k> <C-W>W
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-d> :quit<CR>
nnoremap <silent> ]] :cn<CR>
nnoremap <silent> [[ :cp<CR>
nnoremap <silent> <C-c> :Texplore<CR>
nnoremap <silent> <C-z> :split<CR>
