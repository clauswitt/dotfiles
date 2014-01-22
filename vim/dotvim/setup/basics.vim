let mapleader = ","
set nocompatible                  " Must come first because it changes other options.
set timeout timeoutlen=1000 ttimeoutlen=100

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set pastetoggle=<F2>
set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.



" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=black


set wrap                          " Turn on line wrapping.
set scrolloff=6                   " Show 3 lines of context around the cursor.
set showmatch
set title                         " Set the terminal's title

set visualbell                    " No beeping.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set noswapfile
set backupskip=/tmp/*,/private/tmp/*
set undodir=~/.vim/undo


" UNCOMMENT TO USE
set tabstop=2                    " Global tab width.
set backspace=2
set shiftwidth=2                 " And again, related.
set smarttab
set expandtab                    " Use spaces instead of tabs
set laststatus=2                  " Show the status line all the time
" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{fugitive#statusline()}%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

set autoindent " Indent at the same level as previous line
set smartindent

set list
set listchars=nbsp:¬,tab:>-,extends:»,precedes:«,trail:•

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

set shortmess+=I
