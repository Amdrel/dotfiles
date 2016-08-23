set nocompatible

" Add the cabal bin to the path incase it isn't already there. I use a
" .desktop wrapper for neovim so I miss out on some environment variables.
let $PATH .= ':'.$HOME.'/.cabal/bin'

" Required Vundle setup.
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Syntax highlighting.
Plugin 'a-watson/vim-gdscript'       " GDScript syntax highlighting
Plugin 'beyondmarc/glsl.vim'         " GLSL syntax highlighting
Plugin 'cespare/vim-toml'            " TOML syntax highlighting
Plugin 'hail2u/vim-css3-syntax'      " Better CSS syntax highlighting
Plugin 'leafgarland/typescript-vim'  " Typescript syntax highlighting
Plugin 'mattboehm/Vim-Jinja2-Syntax' " Jinja2 syntax highlighting
Plugin 'mxw/vim-jsx'                 " JSX highlighting (for react)
Plugin 'pangloss/vim-javascript'     " Improved javascript highlighting
Plugin 'rust-lang/rust.vim'          " Rust Syntax highlighting

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

" Omni-completion.
Plugin 'Valloric/YouCompleteMe' " Smart omni-completion w/ popup
Plugin 'eagletmt/neco-ghc'      " Haskell omni-completion
Plugin 'othree/html5.vim'       " HTML5 omni-complete

call vundle#end()

filetype plugin indent on
syntax on

" Fix crappy Mac OS X defaults.
set backspace=indent,eol,start

" Keyboards are for men and mice for wee babies.
set mouse-=a

" Fix status bar behavior.
set laststatus=2

" 80 columns by default.
set colorcolumn=80,100,120

" Never let the cursor hit the very bottom of the screen.
set scrolloff=3

" Highlight search terms, because that should happen.
set hlsearch

" Use 4 space spaces indentation by default, sleuth will automatically set
" these depending on the source file indentation it detects.
set expandtab
set tabstop=4
set shiftwidth=4

" Get rid of lag for exiting visual mode. May also affect other things that I
" am not aware of.
set timeoutlen=1000
set ttimeoutlen=0

" Complete options (disable preview scratch window, longest removed to aways
" show menu) Just bugs me more than I'd prefer.
set completeopt=menu,menuone

" Setup relative line numbers for each buffer.
set nu
set relativenumber

" Retain indentation when inserting new lines.
set autoindent

" Reload changed files if possible.
set autoread

" Disable line wrapping.
set nowrap

" Highlight the current line where the cursor is.
set cursorline

" Wildmenu creates a tab menu similar to fish and zsh. Also add some
" additional rules for case insensitivity.
set wildmenu
set ignorecase
set infercase

" Optimizations, useful for large files with multiple syntax highlighters.
set ttyfast
set lazyredraw

" Fix neovim backups.
set backupdir=~/.local/share/nvim/swap

" Generates a title for the window based on the context of the current buffer.
" If the buffer is a new buffer, show the program name, otherwise show the
" program name along with the buffer name prepended.
function! GetTitle()
  let buffer_name = expand("%:t")

  if len(buffer_name) <= 0
    " No buffer name so just return the program name.
    return g:prog_name
  else
    " Prepend the buffer name to the program name.
    return buffer_name . " - " . g:prog_name
  endif
endfunction

" Automatically reset the title on buffer enter.
autocmd BufEnter * let &titlestring = GetTitle()
set title

" Vim distribution specific configurations.
if has('nvim')
  let g:prog_name = "Neovim"

  " Provide an easy way to escape the terminal.
  tnoremap <C-X> <C-\><C-n>

  " Sakura and iTerm2 uses C-H for backspace since they are sane terminals.
  " Let's map it to move to left window.
  nmap <BS> <C-W>h

  " Change cursor to line cursor while in insert mode. Neovim has first class
  " support for this and may work with more terminals.
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

  set termguicolors

  " Use a full color colorscheme with neovim.
  set background=dark
  colorscheme base16-eighties

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
  colorscheme base16-eighties
endif

" Do OS specific configurations here.
if has("unix")
  let os=substitute(system('uname'), '\n', '', '')

  " Copy to the X11 clipboard, may work with XWayland once my nvidia gpu
  " supports wayland. On Mac OS X use unnamed instead. If on Windows sorry,
  " don't use so I do not know how to get native clipboard support working
  " there.
  if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed

    " YCM won't compile with python 3 on mac for mystical reasons.
    let source_candidate = "/usr/local/bin/python"
    let system_candidate = "/usr/bin/python"
  elseif os == 'Linux' || os == 'FreeBSD' || os == 'OpenBSD' || os == 'NetBSD'
    set clipboard=unnamedplus

    " So basically python can be stored in more than one area. Let's at least
    " check two spots then quit.
    let source_candidate = "/usr/local/bin/python3"
    let system_candidate = "/usr/bin/python3"

    " Get the_silver_surfer working with vim.
    if executable('ag')
      let g:ackprg = "ag --vimgrep"
    endif
  endif
endif

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Bind K to grep the word under the cursor.
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Keep selection when reindenting blocks of selected text.
xnoremap < <gv
xnoremap > >gv

" Keyboard mappings to ex commands.
map <A-k> :NERDTreeFocus<CR>
map <A-j> :NERDTreeClose<CR>
map <F5> :GoRun<CR>

" Window management key mappings. No longer do you need to press C-W to switch
" buffers. C-hjkl can be used to switch between buffers with these mappings.
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

let g:gitgutter_sign_column_always = 1

" Automatically load css colors behind hex codes on file open.
let g:colorizer_auto_filetype='css,html'

" Tweak the html5 completion to be a little more sane by getting rid of useless
" cruft that isn't used often like aria tags.
let g:html5_event_handler_attributes_complete = 0
let g:html5_rdfa_attributes_complete = 0
let g:html5_microdata_attributes_complete = 0
let g:html5_aria_attributes_complete = 0

" Allow auto indenting on these usually blacklisted tags. This means that only
" the <html> tag should not indent.
let g:html_indent_inctags="body,head,tbody"

" I use MySQL alot.
let g:sql_type_default = 'mysql'

" Trigger configuration for UltiSnips.
let g:UltiSnipsExpandTrigger="<c-a>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" Symantic triggers for YCM.
let g:ycm_semantic_triggers={
  \ 'haskell': ['.'],
\ }

" YCM completion options. Includes fixes for omnisharp as well.
let g:ycm_min_num_of_chars_for_completion = 1

" Windows users are out of luck here. I'll port this entire config to windows
" if an evil person ever forces me to use it willingly (I'd probably just
" switch to a virtual machine).
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

let g:ycm_rust_src_path = '/usr/local/rust/rustc-1.10.0/src'
let g:jsx_ext_required = 0

" A nice colored statusline.
let g:airline_theme = 'base16_eighties'

" Enable the airline tabline.
let g:airline#extensions#tabline#enabled = 1

" No powerline today.
let g:airline_powerline_fonts = 0

" Empty separators for powerline.
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

" Set custom airline symbols.
let g:airline_symbols.branch = '⎇ '

" Set the GOPATH.
let $GOPATH=$HOME."/src/go/"

" Only autoclose tags on these file types.
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.tmpl,*.ctp"
