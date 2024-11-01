if !exists('g:plugin_groups')
    let g:plugin_groups=['general', 'autotags', 'autocomplete',  'checker', 'misc']
endif

call plug#begin('~/.vim/pack/dist/start')

" General {
if count(g:plugin_groups, 'general')
    Plug 'mhinz/vim-startify'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'Yggdroot/indentLine'
    Plug 'tpope/vim-fugitive'
    if v:version >= 741 && (has('python') || has('python3'))
        Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    endif
endif

if count(g:plugin_groups, 'autotags')
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'skywind3000/gutentags_plus'
endif

if count(g:plugin_groups, 'autocomplete')
    if has('patch8.0.0027') && (has('python') || has('python3'))
	Plug 'ycm-core/YouCompleteMe'
    elseif has('patch8.0.0027') && has('timers')
	Plug 'prabirshrestha/asyncomplete.vim'
    elseif !has('patch8.2.1066') && has('lua')
	Plug 'Shougo/neocomplete.vim'
    else
	Plug 'Shougo/neocomplcache.vim'
    endif
endif

if count(g:plugin_groups, 'snippet')
    " YCM only support ultisnips
    Plug 'SirVer/ultisnips'
    " Snippets are separated from the engine. Add this if you want them:
    Plug 'honza/vim-snippets'
endif

if count(g:plugin_groups, 'checker')
    Plug 'dense-analysis/ale'
endif

call plug#end()
