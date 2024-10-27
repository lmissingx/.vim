" Basic Settings{
set nocompatible

" Allow baskspace over everything in insert mode
set backspace=indent,eol,start
" Do not recognize octal numbers for Ctrl-A and Ctrl-X,
" most users find it confusing.
set nrformats-=octal
set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶
set fillchars=vert:│,fold:·

set history=200
set showcmd
set wildmenu
set nowrap
set helpheight=10
set textwidth=120
set colorcolumn=+1,+2

set ttimeout
set ttimeoutlen=100

set display+=lastline
set laststatus=2

set scrolloff=3

" in Vim9
let g:mapleader=","

if has("vms")
    set nobackup
else
    set nobackup
    set nowb
    set noswf
    if has('persistent_undo')
        set noundofile
    endif
endif

set ignorecase
set smartcase
" Do incremental searching when it's possible to timeout
if has('reltime')
    set incsearch
endif

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Enable file type detection
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with :filetype off.
filetype plugin indent on

" Switch syntax highlighting on when the terminal has colors or
" when using the GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
    set t_Co=256
    syntax on
    colorscheme desert
    
    "Switch on highlighting the last used search pattern.
    set hlsearch

    " Revert with :unlet c_comment_strings
    let c_comment_strings=1
endif

set foldtext=s:Customfoldtext()
function! s:Customfoldtext() abort
    " get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~# '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let foldsymbol='+'
    let repeatsymbol='-'
    let prefix = foldsymbol . ' '

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = ' ' . foldSize . ' lines '
    let foldLevelStr = repeat('+--', v:foldlevel)
    let lineCount = line('$')
    let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
    let expansionString = repeat(repeatsymbol, w - strwidth(prefix.fodSizeStr.line.foldLevelStr.foldPercentage))
    return prefix . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
