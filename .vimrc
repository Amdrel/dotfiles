set nocompatible

" Add the cabal bin to the path incase it isn't already there. I use a
" .desktop wrapper for neovim so I miss out on some environment variables.
let $PATH .= ':'.$HOME.'/.cabal/bin'.':'.$HOME.'/.nimble/bin'.':'.$HOME.'/.local/bin/nim/bin'

" Required Vundle setup.
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Syntax highlighting.
Plugin 'beyondmarc/glsl.vim'         " GLSL syntax highlighting
Plugin 'cespare/vim-toml'            " TOML syntax highlighting
Plugin 'hail2u/vim-css3-syntax'      " Better CSS syntax highlighting
Plugin 'leafgarland/typescript-vim'  " Typescript syntax highlighting
Plugin 'mattboehm/Vim-Jinja2-Syntax' " Jinja2 syntax highlighting
Plugin 'mxw/vim-jsx'                 " JSX highlighting (for react)
Plugin 'pangloss/vim-javascript'     " Improved javascript highlighting
Plugin 'rust-lang/rust.vim'          " Rust syntax highlighting
Plugin 'zah/nim.vim'                 " Nim syntax highlighting

" Editing.
Plugin 'Chun-Yang/auto-pairs'         " Match commonly paired characters
Plugin 'SirVer/ultisnips'             " Snippets for most languages
Plugin 'Valloric/MatchTagAlways'      " Matches visible html tags
Plugin 'alvan/vim-closetag'           " Close html tags automatically
Plugin 'chrisbra/Colorizer'           " CSS hex highlighter
Plugin 'fatih/vim-go'                 " Golang IDE/like features
Plugin 'honza/vim-snippets'           " Snippets for ultisnips
Plugin 'hynek/vim-python-pep8-indent' " Fix for python indentation
Plugin 'itchyny/vim-haskell-indent'   " Fix haskell indentation
Plugin 'tpope/vim-sleuth'             " File indentation detection
Plugin 'tpope/vim-surround'           " Allow easy surrounding edits

" Themes.
Plugin 'chriskempson/base16-vim' " Base16 theme for vim
Plugin 'flazz/vim-colorschemes'  " Every known colorscheme

" Utility.
Plugin 'Shougo/vimproc.vim'             " Asynchronous execution library
Plugin 'VundleVim/Vundle.vim'           " Plugin manager for vim
Plugin 'airblade/vim-gitgutter'         " Display changed lines in gutter
Plugin 'artnez/vim-wipeout'             " Allows closing of hidden buffers
Plugin 'ctrlpvim/ctrlp.vim'             " File fuzzy finder
Plugin 'mileszs/ack.vim'                " Frontend for ag grepping
Plugin 'scrooloose/nerdtree'            " File viewer for current dir
Plugin 'tpope/vim-fugitive'             " Embedded git client
Plugin 'vim-airline/vim-airline'        " Fancy statusline
Plugin 'vim-airline/vim-airline-themes' " Themes for airline
Plugin 'jceb/vim-orgmode'               " Org-Mode for vim

" Omni-completion.
Plugin 'Valloric/YouCompleteMe' " Smart omni-completion w/ popup
Plugin 'eagletmt/neco-ghc'      " Haskell omni-completion
Plugin 'othree/html5.vim'       " HTML5 omni-complete

" Linting
Plugin 'neomake/neomake' "Async linting for various languages

call vundle#end()

filetype plugin indent on
syntax on

" Default indentation settings (sleuth overrides per buffer).
set expandtab
set tabstop=4
set shiftwidth=4

" Fix crappy Mac OS X defaults.
set backspace=indent,eol,start

" Visual mode lag workaround.
set timeoutlen=1000
set ttimeoutlen=0

set mouse=a
set laststatus=2
set colorcolumn=80,100,120
set scrolloff=3
set hlsearch
set completeopt=menu,menuone
set nu
set relativenumber
set autoindent
set autoread
set nowrap
set cursorline
set wildmenu
set noignorecase
set infercase
set ttyfast
set lazyredraw
set title

" Fix neovim backups.
set backupdir=~/.local/share/nvim/swap

" Set's some code style settings for when working in the linux kernel. This
" can be made automatic at some point by checking if we're in a git repo or
" something else equally hacky.
function LoadLinuxKernelDefaults()
  set noexpandtab
  set shiftwidth=8
  set softtabstop=8
  set tabstop=8
endfunction

" Generates a title for the window based on buffer contents.
function! GetTitle()
  let buffer_name = expand("%:t")

  if len(buffer_name) <= 0
    return g:prog_name
  else
    return buffer_name . " - " . g:prog_name
  endif
endfunction

" Automatically reset the title on buffer enter.
autocmd BufEnter * let &titlestring = GetTitle()

" Vim distribution specific configurations.
if has('nvim')
  let g:prog_name = "Neovim"

  " Provide an easy way to escape the built-in terminal.
  tnoremap <C-X> <C-\><C-n>

  " Sakura and iTerm2 uses C-H for backspace since they are sane terminals.
  " Let's map it to move to left window.
  nmap <BS> <C-W>h

  " Change cursor to line cursor while in insert mode. Neovim has first class
  " support for this and may work with more terminals.
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

  set signcolumn=yes

  " Use a full color colorscheme with neovim.
  set termguicolors
  set background=dark
  colorscheme base16-onedark

  " Fix terrible hard to read cursor color.
  hi MatchParen guifg=#F8F8F0 guibg=#444444 gui=bold
else
  let g:prog_name = "Vim"

  " Allows vanilla vim to switch the cursor type on insert and back on return
  " to normal mode. This terminal hack that may not work for all.
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"

  " Non true color colorscheme since vim does not support true color.
  set background=dark
  let base16colorspace=256
  colorscheme base16-onedark
endif

" Do OS specific configurations here.
if has("unix")
  let os=substitute(system('uname'), '\n', '', '')

  " Support system clipboard on Mac OS and X11 *nix. Also works with XWayland.
  " Windows clipboard integration currently doesn't work.
  if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
    let source_candidate = "/usr/local/bin/python" " Python3 + Mac OS = hell.
    let system_candidate = "/usr/bin/python"
  elseif os == 'Linux' || os == 'FreeBSD' || os == 'OpenBSD' || os == 'NetBSD'
    set clipboard=unnamedplus
    let source_candidate = "/usr/local/bin/python3"
    let system_candidate = "/usr/bin/python3"

    if executable('ag')
      let g:ackprg = "ag --vimgrep"
    endif
  endif
endif

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor " Use ag over grep
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' "Use ag in CtrlP
  let g:ctrlp_use_caching = 0 " ag don't need no caching (it's fast)
endif

" Keep selection when reindenting blocks of selected text.
xnoremap < <gv
xnoremap > >gv

" Keyboard mappings to ex commands.
map <A-k> :NERDTreeFocus<CR>
map <A-j> :NERDTreeClose<CR>
map <F5> :GoRun<CR>

" Window management key mappings so C-W doesn't need to be used in certain
" scenarios. C-hjkl can be used to switch between buffers with these mappings.
"
" C-h may not work for some terminals as it's interpreted as BS, so BS is
" mapped to C-W h if this is the case (see above).
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

let g:colorizer_auto_filetype='css,html' " CSS hex color backgrounds.
let g:html5_event_handler_attributes_complete = 0
let g:html5_rdfa_attributes_complete = 0
let g:html5_microdata_attributes_complete = 0
let g:html5_aria_attributes_complete = 0
let g:html_indent_inctags="body,head,tbody"
let g:sql_type_default = 'mysql'
let g:UltiSnipsExpandTrigger="<c-a>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" Symantic triggers for YCM.
let g:ycm_semantic_triggers={
  \ 'haskell': ['.'],
\ }
let g:ycm_min_num_of_chars_for_completion = 1

" YCM is configured only to with with *nix at the moment.
if filereadable(source_candidate)
  let g:ycm_path_to_python_interpreter = source_candidate
elseif filereadable(system_candidate)
  let g:ycm_path_to_python_interpreter = system_candidate
endif

" Fix highlighting for select files.
autocmd BufNewFile,BufRead *.gd set filetype=gdscript
autocmd BufNewFIle,BufRead *.zsh-theme set filetype=sh
autocmd BufNewFIle,BufRead app.component set filetype=typescript

" Fix CSS highlighting due to problems with vim priorities.
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

" Disable haskell-vim omnifunc.
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:ycm_rust_src_path = '/usr/local/rust/rustc-current/src'
let g:jsx_ext_required = 0
let g:airline_theme = 'base16_ashes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch = '⎇ '
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.tmpl,*.ctp,*.erb"

let $GOPATH=$HOME."/src/go/"
