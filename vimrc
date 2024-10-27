" set default encoding to utf-8
" Let Vim use utf-8 internally, because many scripts require this
set encoding=utf-8  " (set encoding used inside Vim)
scriptencoding utf-8


" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

let s:cur_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:root_dir = escape(fnamemodify(resolve(fnamemodify(expand('<sfile>'), 
            \ ':p:h:gs?\\?'.((has('win16') || has('win32')
            \ || has('win64'))?'\':'/') . '?')), ':p:gs?[\\/]?/?'), ' ')
lockvar g:root_dir
exec 'set rtp+='. fnameescape(g:root_dir. '/.vim')
command! -nargs=1 IncScript exec 'so'. fnameescape(s:cur_dir."/<args>")

IncScript basic.vim
"Incscript plugin.vim
" Get the plugin
if filereadable(expand("~/.vim/pack.vim"))
    source ~/.vim/pack.vim
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Only do this part when Vim was compiled with the +eval feature.
if 1

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with :filetype off.
" filetype plugin indent on

" Put these in an autocmd group, so that you can revert them with:
" ":autocmd! vimStartup"
augroup vimStartup
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim), for a commit or rebase message
  " (likely a different one than last time), and when using xxd(1) to filter
  " and edit binary files (it transforms input files back and forth, causing
  " them to have dual nature, so to speak)
  autocmd BufReadPost *
    \ let line = line("'\"")
    \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif

augroup END

" Quite a few people accidentally type "q:" instead of ":q" and get confused
" by the command line window.  Give a hint about how to get out.
" If you don't like this you can put this in your vimrc:
" ":autocmd! vimHints"
augroup vimHints
  au!
  autocmd CmdwinEnter *
 \ echohl Todo |
 \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
 \ echohl None
augroup END

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
    packadd! matchit
endif

" Plugins {
" General {
if isdirectory(expand("~/.vim/pack/dist/start/vim-startify"))
endif

if isdirectory(expand("~/.vim/pack/dist/start/vim-airline"))
    let g:airline_theme='alduin'
    if v:version > 900
        let g:airline_experimental = 1
    endif

    let g:airline_detect_paste = 1
    let g:airlilne_filetype_overrides = {
                \ 'help': [ 'Help', '%f'],
                \ }
    let g:airline#extensions#ale#enabled = 1
    let g:airline#extensions#ale#error_symbol = 'E:'
    let g:airline#extensions#ale#warning_symbol = 'W:'
    
    " enable/disable fugitive/lawrencium integration
    let g:airline#extensions#branch#enabled = 1

    " define the order in which the branches of different vcs systems will be displayed
    let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]

    let g:airline#extensions#branch#vcs_checks = ['untracked', 'dirty']

    " enable/disable vim-gutentags integration
    let g:airline#extensions#gutentags#enabled = 1
endif

if isdirectory(expand("~/.vim/pack/dist/start/indentLine"))
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    let g:indentLine_char = '┊'
    let g:indentLine_fileType = ['c', 'cpp']
    let g:indentLine_fileTypeExclude = ['text', 'sh']
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']
    let g:indentLine_autoResetWidth = 1
endif

if isdirectory(expand("~/.vim/pack/dist/start/vim-fugitive"))
endif

if isdirectory(expand("~/.vim/pack/dist/start/LeaderF"))
    " more prompt in help 1365page
    let g:Lf_ShortcutF = '<C-P>'
    let g:Lf_ShortcutB = '<leader>b'
    let g:Lf_WindowHeight = 0.30
    if (exists('*popup_create') && has('patch-8.1.2000')) || has('nvim-0.4')
        let g:Lf_PreviewInPopup = 1
        let g:Lf_WindowPosition = 'popup'
    endif
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_CacheDirectory = expand('~/.cache')
    let g:Lf_IndexTimeLimit = 20
    let g:Lf_RootMarkers = ['.git', '.svn', '.hg']
    let g:Lf_WildIgnore = {
                \ 'dir': ['.git','.svn','.hg'],
                \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
                \ }
    let g:Lf_MruFileExclude = ['*.so']
    let g:Lf_MruMaxFiles = 50
    let g:Lf_NumberOfHighlight = 50
    " if don't let LeaderF modify statusline
    " let g:Lf_DisableStl = 1
    let g:Lf_Ctags = "~/.vim/bin/universal-ctags/bin/ctags"
    let g:Lf_CtagsFuncOpts = {
                \ 'c': '--c-kinds=fp',
                \ 'rust': '--rust-kinds=f',
                \ }
    " to specify the default external tool which is used to index the files.
    " Possible values are 'rg', 'pt', 'ag', 'find'.
    " let g:Lf_DefaultExternalTool = \""

    " specify a external command to index the files
    " g:Lf_UseVersionControlTool and g:Lf_DefaultExternalTool are
    " ignored if this option is specified.
    " let g:Lf_ExternalCommand = 'find \"%s" -type f'

    let g:Lf_NormalMap = {
                \ "_":      [["<C-j>", "j"],
                \            ["<C-k>", "k"]
                \           ],
                \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>'],
                \            ["<F6>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']
                \           ],
                \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>'],
                \            ["<F6>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']
                \           ],
                \ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
                \ "Tag":    [],
                \ "BufTag": [],
                \ "Function": [],
                \ "Line":   [],
                \ "History":[],
                \ "Help":   [],
                \ "Self":   [],
                \ "Colorscheme": []
                \ }
    let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
    let g:Lf_NormalCommandMap = {
        \ "*":      {
        \               "<C-Down>": "<C-J>",
        \               "<C-Up>":   "<C-K>"
        \           },
        \ "File":   {
        \               "q":     "<Esc>",
        \               "a":     "<C-A>",
        \               "<Esc>": "<C-W>",
        \           },
        \ "Buffer": {},
        \ "Mru":    {},
        \ "Tag":    {},
        \ "BufTag": {},
        \ "Function": {},
        \ "Line":   {},
        \ "History":{},
        \ "Help":   {},
        \ "Rg":     {},
        \ "Gtags":  {},
        \ "Colorscheme": {}
        \ }

    " specify the rg executable path
    " let g:Lf_Rg = 'C:\Windows\System32\rg.exe'
    " Specify a list of ripgrep configurations. For example,
    " let g:Lf_RgConfig = [
    "     \ \"--max-columns=150",
    "     \ ]

    " customize the global executable to use
    "let g:Lf_Global = \"/bin/global"
    "or let g:Lf_Gtags = \"/bin/gtags"
    let g:Lf_GtagsAutoGenerate = 0
    let g:Lf_GtagsGutentags = 1
    let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/LeaderF/gtags')
    let g:Lf_GtagsSkipUnreadable = 1
    let g:Lf_GtagsSkipSymlink = 'a'

    " Open the commands panel using :Leaderf git .
    let g:Lf_GitCommands = [
        \ {"Leaderf git diff":                "fuzzy search and view the diffs"},
        \ {"Leaderf git diff --cached":       "fuzzy search and view `git diff --cached`"},
        \ {"Leaderf git diff HEAD":           "fuzzy search and view `git diff HEAD`"},
        \ {"Leaderf git diff --side-by-side": "fuzzy search and view the side-by-side diffs"},
        \ ]
    " :LeaderfGitSplitDiff :A shortcut of :Leaderf git diff --current-file --side-by-side
    " some handy maps for Leaderf rg,please check leaderf help 1340page
    " Some handy maps for Leaderf gtags in 1362page

endif
" }

"autotag {
if isdirectory(expand("~/.vim/pack/dist/start/vim-gutentags"))
    let g:gutentags_define_advanced_commands = 1
    let g:gutentags_project_root = ['.root', '.project', '.git', '.svn', '.hg']
    let g:gutentags_cache_dir = expand('~/.cache/LeaderF/gtags')
    let g:gutentags_ctags_tagfile = '.tags'
    if executable('ctags')
        let g:gutentags_modules = ['ctags']
    endif
    if executable('gtags') && executable('gtags-cscope')
        let g:gutentags_modules += ['gtags_cscope']
    endif
    let g:gutentags_exclude_project_root = ['/usr/local', '/opt/homebrew', '/home/linuxbrew/.linuxbrew']
    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
    " gutentags_plus{
    " change focus to quickfix window after search (optional).
    let g:gutentags_plus_switch = 1
    let g:gutentags_plus_nomap = 1
    "Find symbol (reference) under cursor
    noremap <silent> <leader>gss :GscopeFind s <C-R><C-W><cr>
    "Find symbol definition under cursor
    noremap <silent> <leader>gsg :GscopeFind g <C-R><C-W><cr>
    "Find functions called by this function
    noremap <silent> <leader>gsd :GscopeFind d <C-R><C-W><cr>
    "Find functions calling this function
    noremap <silent> <leader>gsc :GscopeFind c <C-R><C-W><cr>
    "Find text string under cursor
    noremap <silent> <leader>gst :GscopeFind t <C-R><C-W><cr>
    "Find egrep pattern under cursor
    noremap <silent> <leader>gse :GscopeFind e <C-R><C-W><cr>
    "Find file name under cursor
    noremap <silent> <leader>gsf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    "Find files #including the file name under cursor
    noremap <silent> <leader>gsi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    "Find places where current symbol is assigned
    noremap <silent> <leader>gsa :GscopeFind a <C-R><C-W><cr>
    "Find current word in ctags database
    noremap <silent> <leader>gsz :GscopeFind z <C-R><C-W><cr>
    " }
endif
"}

" ale {
if isdirectory(expand("~/.vim/pack/dist/start/ale"))
    " let g:ale_linters = { }
    nmap <silent> <leader>a <Plug>(ale_next_wrap)
    " Only run linting when saving the file
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_enter = 0
    let g:ale_virtualtext_cursor = 'disabled'
endif
" }
