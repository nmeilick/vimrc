scriptencoding utf-8
" Version: 2023-05-18

" -----------------
" General Settings
" -----------------
set nocompatible                  " Enable Vi incompatible features
set encoding=utf-8                " Internal encoding
set fileencoding=utf-8            " Default encoding when writing files
set ff=unix                       " Unix line endings
filetype plugin on                " Per-filetype settings
filetype indent on                " Per-filetype indentation
syntax on                         " enable syntax highlighting
set dictionary=~/.vim/dicts/english,~/.vim/dicts/german  " set wordlists for CTRL-X CTRL-K completion

" -----------------
" Default Settings
" -----------------
set textwidth=120                 " Maximum width of text
set tabstop=2                     " Width of a tab character
set shiftwidth=2                  " Number of spaces used for each step of indentation
set softtabstop=2                 " Number of spaces a tab counts for while performing editing
set expandtab                     " Use spaces instead of tabs
set autoindent                    " Copy indent from current line when starting a new line
set autoread                      " Read file if it wasn't changed in Vim but changed externally
set backspace=indent,eol,start    " Allow backspacing over everything in insert mode
set shiftround                    " Round > < to shiftwidth
set noignorecase nosmartcase      " Disable case-sensitivity
set noerrorbells visualbell t_vb= " Don't ring the bell
set incsearch                     " Incremental search
set mousehide                     " Hide the mouse cursor while typing
set sc                            " Show incomplete commands
set updatetime=200                " Interval in milliseconds to update swap file
set updatecount=200               " Number of changes before updating swap file
let mapleader=","                 " Set the mapleader
set wildmode=longest,list         " Filename completion mode
set nostartofline                 " Keep cursor column when scrolling by page
"set mouse=a                       " enable mouse support
set directory=.                   " Swap file directory
set history=50                    " Command line history length
set nofoldenable

" Backup, Views and Undo -----------------------------------------------------
if !has("nvim")
  silent !mkdir -p ~/.vim/tmp/{backup,view,undo}
endif

" Backup settings
set backup                                     " Enable backup files
set backupcopy=yes                             " Make a copy of the original file before overwriting
set backupdir=~/.vim/tmp/backup//,.            " Backup directory location
set backupext=~                                " Backup file extension
set backupskip=/tmp/*,/dev/shm/*,*/.cfs*/*     " Skip these directories for backup
set patchmode=.bak                             " Create a backup file when using patches
let savevers_dirs=&backupdir                   " Save versions directory
let savevers_max=999                           " Maximum number of versions

" View settings
set viewdir=~/.vim/tmp/view//     " View directory location

" Viminfo settings
set viminfofile=~/.vim/.viminfo
"set viminfo='5,"0,:50
set viminfo='0,:10,<0,@0,f0,/10

" Undo settings
set undodir=~/.vim/tmp/undo//     " set the undo directory location
set noundofile                    " do not use an undo file by default
set undolevels=5000               " Maximum number of changes to remember in the undo tree
set undoreload=1000000            " Maximum number of lines to save for a buffer

" -----------------
" Display Settings
" -----------------
set colorcolumn=+1                " highlight the textwidth+1 column
set nocursorline                  " disables highlighting of the current line
set visualbell t_vb=              " Disable visual bell
set formatoptions+=tcrq           " Format options
set formatoptions+=qnj            " Format options
set nojoinspaces                  " No extra space after '.' when joining lines
set listchars=tab:>‸,trail:‸,extends:>,precedes:< " Show special characters
set list                          " Show listchars
set matchpairs=(:),{:},[:],<:>     " Match pairs of characters
set matchtime=7                   " Time to show matching paren in tenths of a second
set modifiable                    " Buffer can be modified
set clipboard+=autoselect         " Automatically select text for clipboard
set nopaste                       " Disable paste mode
set report=2                      " Number of lines to report for join, delete or shift
set restorescreen                 " Restore screen after external command
set shell=bash                    " Use bash as shell
set shiftwidth=2                  " Number of spaces used for each step of indentation
set showbreak=\|                  " String to show at the start of wrapped lines
set showfulltag                   " Show complete tag when completing
set showmatch                     " Show matching brackets
set sidescroll=1                  " Minimal number of columns to scroll horizontally
set swapsync=                     " Swap file sync method
set nowarn                        " Don't give warning messages
set nowrap                        " Do not wrap long lines
set nowrapscan                    " Searches wrap around the end of the file
set whichwrap+=<>                 " Allow left and right cursor keys to move between lines
set scrolloff=3                   " Minimal number of screen lines to keep above and below the cursor
set sidescrolloff=3               " Minimal number of screen columns to

" --- Theme and visual settings ---------------------------------------------------
set t_Co=256                      " set color scheme to 256 colors
set background=dark               " set background to dark
set number                        " show line numbers
set ruler                         " show ruler at cursor position
"set cursorline                    " highlight current line
set hlsearch                      " highlight search results
set showmatch                     " show matching parentheses
set gcr=n:blinkon0                " turn off blinking cursor in normal mode
set lazyredraw                    " redraw only when necessary
set display=uhex,lastline         " display settings
set modeline                      " enable modelines
set modelines=5                   " set number of lines to check for modelines
set wmnu                          " show possible completions
set title                         " set title of window
set titlelen=85                   " set maximum length of the title
set titleold="VIM could not restore title"      " set title when Vim cannot restore it
autocmd BufEnter * let &titlestring = "%<%F" . " @ " . hostname() . "%=%l/%L-%P"
set laststatus=2                  " always show status line

if has("gui_running")
  " GUI is running or is about to start.
  set lines=80 columns=237
  set guioptions -=T
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 12
  if filereadable(expand("~/.vimrc_background")) " for base16 colorschemes
    let base16colorspace=256
    source ~/.vimrc_background
  endif
endif

" --- File type specific settings and mappings -------------------------------
augroup configgroup
  autocmd!

  " View management
  autocmd GUIEnter *.* set visualbell t_vb=           " Disable visual bell
  autocmd BufWinEnter *.* loadview                    " Load saved views
  autocmd BufWinLeave *.* mkview                      " Save views on leave

  autocmd OptionSet textwidth set colorcolumn=+1      " update colorcolumn when textwidth changes

  " File type specific settings
  autocmd FileType go call SetupGo()                  " Go configuration
  autocmd FileType ruby call SetupRuby()              " Ruby configuration
  autocmd FileType python call SetupPython()          " Python configuration
  autocmd FileType make setlocal noexpandtab          " Makefile - disable expandtab
  autocmd FileType gitcommit call SetupGitcommit()    " Git commit configuration
  autocmd FileType mail setlocal tw=120               " Set textwidth for mail files

  " Strip trailing whitespace on save
  autocmd FileType c,cpp,go,java,,php,javascript,puppet,python,ruby,rust,sh,twig,xml,yml,perl,sql,vim,gitcommit autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  " Refresh vimrc after saving
  autocmd BufWritePost ~/.vimrc source %                        " Reload vimrc after save

  " Undo handling
  autocmd BufReadPost * call ReadUndo()
  autocmd BufWritePost * call WriteUndo()
augroup END

" --- Bindings ---------------------------------------------------------------
" Move cursor up or down one line despite line breaks
map <Up> gk
imap <Up> <C-o>gk
map <Down> gj
imap <Down> <C-o>gj

" No highlight search
nnoremap <Leader><space> :nohlsearch<CR>

" Gundo
nnoremap <Leader>u :GundoToggle<CR>

" Toggle paste mode
nnoremap <F5> :call TogglePaste()<CR>
inoremap <F5> <C-o>:call TogglePaste()<CR>
set pastetoggle=<F5>

" Toggle relativenumber
nnoremap <F6> :let &rnu=!&rnu<CR>
inoremap <F6> <C-o>:let &rnu=!&rnu<CR>

" Toggle spellcheck
nnoremap <F7> :let &spell=!&spell<CR>
inoremap <F7> <C-o>:let &spell=!&spell<CR>

" sudo save
cmap w!! w !sudo tee > /dev/null %

" Write buffer to git diff command
cmap diffw exec 'w !git diff --no-index -- - ' . shellescape(expand('%'))

" Update diff after write
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

" Indent/Unindent visual blocks
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"---Plugins------------------------------------------------------------------
call plug#begin()
  " Color schemes
  Plug 'dracula/vim'                 " Dracula color scheme
  Plug 'chriskempson/base16-vim'     " Base16 color schemes

  " Icons and UI
  Plug 'ryanoasis/vim-devicons'      " Icons for various file types
  Plug 'vim-airline/vim-airline'     " Better status line
  Plug 'vim-airline/vim-airline-themes' " Airline themes

  " File navigation and management
  Plug 'scrooloose/nerdtree'         " File explorer
  Plug 'preservim/nerdcommenter'     " Commenting utility
  Plug 'tpope/vim-fugitive'          " Git integration

  " Editing and formatting
  Plug 'honza/vim-snippets'          " Code snippets
  Plug 'godlygeek/tabular'           " Align text
  Plug 'preservim/vim-markdown'      " Markdown support
  Plug 'sbdchd/neoformat'            " Code formatting
  Plug 'AndrewRadev/splitjoin.vim'   " Split and join lines
  Plug 'terryma/vim-multiple-cursors' " Multiple cursors support
  Plug 'z0mbix/vim-shfmt'            " Shell script formatting

  " Language specific plugins
  Plug 'fatih/vim-go'                " Go development environment
  Plug 'SirVer/ultisnips'            " Snippet engine

  " Misc
  Plug 'vim-scripts/savevers.vim'    " Keep backups of edited files
  Plug 'sjl/gundo.vim'               " Visual undo tree
  Plug 'edkolev/promptline.vim'      " Custom shell prompt
  Plug 'madox2/vim-ai'               " AI support

  " Neovim specific plugins
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete for Neovim
    Plug 'zchee/deoplete-jedi'      " Python autocompletion
  endif
call plug#end()

" --- Functions --------------------------------------------------------------
function! SetupDefaults()
  setlocal expandtab
  setlocal shiftwidth=2
  setlocal softtabstop=2
  setlocal tabstop=2
  setlocal shiftwidth=2
endfunction

function! SetupGo()
  call SetupDefaults()
  setlocal commentstring=//\ %s
  setlocal nolist
  "setlocal completeopt-=preview
  setlocal completeopt=longest,menuone
  let g:neocomplete#enable_auto_close_preview = 1
  let g:go_fmt_command = "goimports"
  let g:go_snippet_case_type = "camelcase"

  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_interfaces = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = "goimports"
  let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
  let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

  inoremap <buffer> . .<C-x><C-o>
  nmap <Leader>s <Plug>(go-implements)
  nmap <Leader>i <Plug>(go-info)
  nmap <Leader>e <Plug>(go-rename)
  nmap <leader>r <Plug>(go-run)
  nmap <leader>b <Plug>(go-build)
  nmap <leader>t <Plug>(go-test)
  nmap <Leader>gd <Plug>(go-doc)
  nmap <Leader>gv <Plug>(go-doc-vertical)
  nmap <leader>co <Plug>(go-coverage)
endfunction

function! SetupPython()
  call SetupDefaults()
  setlocal commentstring=#\ %s
  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 shiftwidth=4
endfunction

function! SetupGitcommit()
  setlocal spell indentexpr='' expandtab shiftwidth=4 tabstop=4 textwidth=72 colorcolumn=+1
  call setpos('.', [0, 1, 1, 0])
endfunction

function! CriticalFile()
  let patterns = ['^/tmp/.*','^/dev/shm/.*','^.*/\.cfs.*/.*']
  let file = fnamemodify(expand('%'), ':p')
  for pattern in patterns
    if match(file, pattern) != -1
      return 1
    endif
  endfor
  return 0
endfunction

func ReadUndo()
  if CriticalFile()
    return
  endif
  let file = undofile(bufname('%'))
  if filereadable(file)
    silent! execute 'rundo '.escape(file, '% ')
  endif
endfunc

func WriteUndo()
  if CriticalFile()
    return
  endif
  let file = undofile(bufname('%'))
  let efile = escape(file, '% ')
  "if filereadable(file)
  "  execute 'move '.efile.' '.efile.'.bak'
  "endif
  silent! execute 'wundo '.efile
endfunc

function! StripTrailingWhitespace()
    set modifiable
    " save last search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    " strip
    %s/\s\+$//e
    " restore previous search history and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! TogglePaste()
    if(&number == 1)
        set nonumber
        set paste
    else
        set number
        set nopaste
    endif
endfunc

" --- Plugin settings --------------------------------------------------------
if has('nvim')
lua << EOF
  require'lspconfig'.gopls.setup{}   " Go language server setup
EOF
endif

" --- General Plugins --------------------------------------------------------
let g:python3_host_prog = "/usr/bin/python3" " Set python3 interpreter path
let g:loaded_perl_provider = 0               " Disable perl provider
let g:deoplete#enable_at_startup = 1         " Enable deoplete at startup
let g:neocomplete#enable_at_startup = 1      " Enable neocomplete at startup
let g:jedi#completions_enabled = 0           " Disable jedi completions
let g:jedi#use_splits_not_buffers = "right"  " Jedi use splits not buffers
let g:is_posix = 1                           " Set environment to POSIX
let g:shfmt_fmt_on_save = 0                  " Disable shfmt on save
let g:shfmt_extra_args = '-i 2'              " Shfmt extra arguments
let g:neural = { 'source': { 'openai': { 'api_key': $OPENAI_API_KEY, }, }, } " OpenAI API Key

" --- Airline Plugins --------------------------------------------------------
let g:airline_powerline_fonts = 0             " Disable powerline fonts
let g:airline#extensions#tabline#enabled = 1  " Enable airline tabline
let g:airline#extensions#branch#enabled = 1   " Enable airline git branch
let g:airline#extensions#syntastic#enabled = 1 " Enable airline syntastic
let g:airline#extensions#tagbar#enabled = 1   " Enable airline tagbar
let g:airline#extensions#whitespace#enabled = 1 " Enable airline whitespace
let g:airline#extensions#whitespace#mixed_indent_algo = 2 " Mixed indent algorithm
let g:airline#extensions#whitespace#symbol = 'Ξ' " Whitespace symbol
let g:airline#extensions#tmuxline#enabled = 1 " Enable airline tmuxline
let g:airline_detect_modified = 1             " Detect modified files
let g:airline_detect_paste = 1                " Detect paste mode
let g:airline_left_sep = '▶'                  " Airline left separator
let g:airline_right_sep = '◀'                 " Airline right separator

let g:vim_ai_chat = {
  \  "options": {
  \    "model": "gpt-4",
  \    "temperature": 0.2,
  \  },
  \}

" complete text on the current line or in visual selection
nnoremap <leader>a :AI<CR>
xnoremap <leader>a :AI<CR>

" edit text with custom context
xnoremap <leader>s :AIEdit fix grammar and spelling<CR>
nnoremap <leader>s :AIEdit fix grammar and spelling<CR>

" trigger chat
xnoremap <leader>c :AIChat<CR>
nnoremap <leader>c :AIChat<CR>

" redo last AI command
nnoremap <leader>r :AIRedo<CR>

" trigger improvement
xnoremap <leader>i :AIPromptCodeImprovement<CR>
nnoremap <leader>i :AIPromptCodeImprovement<CR>

function! AIPromptCommitMessageFn()
  let l:diff = system('git diff --staged')
  let l:prompt = "generate a short commit message from the diff below:\n" . l:diff
  let l:range = 0
  let l:config = {
  \  "engine": "chat",
  \  "options": {
  \    "model": "gpt-3.5-turbo",
  \    "initial_prompt": ">>> system\nyou are a code assistant",
  \    "temperature": 1,
  \  },
  \}
  call vim_ai#AIRun(l:range, l:config, l:prompt)
endfunction
command! AIPromptCommitMessage call AIPromptCommitMessageFn()

" custom command that provides a code review for selected code block
function! AIPromptCodeReviewFn(range) range
  let l:prompt = "programming syntax is " . &filetype . ", review the code below"
  let l:config = {
  \  "options": {
  \    "initial_prompt": ">>> system\nyou are a clean code expert",
  \  },
  \}
  '<,'>call vim_ai#AIChatRun(a:range, l:config, l:prompt)
endfunction
command! -range AIPromptCodeReview <line1>,<line2>call AIPromptCodeReviewFn(<range>)

" custom command that improves code
function! AIPromptCodeImprovementFn(range) range
  let l:prompt = "programming syntax is " . &filetype . ", add useful comments and suggest improvements"
  let l:config = {
  \  "options": {
  \    "model": "gpt-4",
  \    "initial_prompt": ">>> system\nyou are a clean code expert",
  \  },
  \}
  '<,'>call vim_ai#AIChatRun(a:range, l:config, l:prompt)
endfunction
command! -range AIPromptCodeImprovement <line1>,<line2>call AIPromptCodeImprovementFn(<range>)
