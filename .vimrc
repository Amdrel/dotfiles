set nocompatible
filetype off

" Required Vundle setup.
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'Chun-Yang/auto-pairs'
Plugin 'Valloric/MatchTagAlways'
Plugin 'Valloric/YouCompleteMe'
Plugin 'VundleVim/Vundle.vim'
Plugin 'alvan/vim-closetag'
Plugin 'cespare/vim-toml'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'fatih/vim-go'
Plugin 'flazz/vim-colorschemes'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mattboehm/Vim-Jinja2-Syntax'
Plugin 'mileszs/ack.vim'
Plugin 'othree/html5.vim'
Plugin 'quabug/vim-gdscript'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sleuth'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()

filetype plugin indent on
syntax on

" Fix crappy Mac OS X defaults.
set backspace=indent,eol,start

set laststatus=2

set nu
set autoindent
set autoread
set nowrap
set cursorline
set wildmenu
set ttyfast
set lazyredraw

" Fix neovim backups.
set backupdir=~/.local/share/nvim/swap

if has('nvim')
  let g:prog_name = "Neovim"

  " Provide an easy way to escape the terminal.
  tnoremap <C-X> <C-\><C-n>

  " Change cursor to line cursor while in insert mode.
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
else
  let g:prog_name = "Vim"

  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

xnoremap < <gv
xnoremap > >gv

" Keyboard mappings to ex commands.
map <A-k> :NERDTreeFocus<CR>
map <A-j> :NERDTreeClose<CR>
map <F5> :GoRun<CR>

" Window management key mappings.
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

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

let g:html5_event_handler_attributes_complete = 0
let g:html5_rdfa_attributes_complete = 0
let g:html5_microdata_attributes_complete = 0
let g:html5_aria_attributes_complete = 0

" Allow auto indenting on these usually blacklisted tags. This means that only
" the <html> tag should not indent.
let g:html_indent_inctags="body,head,tbody"

" I use MySQL alot.
let g:sql_type_default = 'mysql'

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

" Symantic triggers for YCM.
let g:ycm_semantic_triggers={
  \ 'html': ['re!\s*', '<'],
  \ 'jinja': ['re!\s*', '<'],
  \ 'gohtmltmpl': ['re!\s*', '<'],
  \ 'css': ['re!^\s*', 're!:\s+']
\ }

let g:ycm_min_num_of_chars_for_completion = 1

" Fix highlighting for select files.
autocmd BufNewFile,BufRead *.gd set filetype=gdscript
autocmd BufNewFIle,BufRead *.zsh-theme set filetype=sh

" A nice colored statusline.
let g:airline_theme = 'badwolf'

" Remove the arrows.
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch = '⎇ '

" Copy to the X11 clipboard, may work with XWayland once my nvidia gpu
" supports wayland. On Mac OS X use unnamed instead. If on Windows sorry,
" don't use so I do not know how to get native clipboard support working
" there.
if has("unix")
  let os=substitute(system('uname'), '\n', '', '')

  if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
  elseif os == 'Linux' || os == 'FreeBSD' || os == 'OpenBSD' || os == 'NetBSD'
    set clipboard=unnamedplus

    " Get the_silver_surfer working with vim.
    let g:ackprg = "ag --vimgrep"
  endif
endif

" Set the GOPATH.
let $GOPATH=$HOME."/src/go/"

" Only autoclose tags on these file types.
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.tmpl,*.ctp"

" Fancy colors fancy time!
if has('nvim')
  set background=dark
  colorscheme badwolf

  " Fix terrible hard to read cursor color.
  hi MatchParen guifg=#F8F8F0 guibg=#444444 gui=bold
else
  set background=dark
  colorscheme badwolf
endif

" Snippets

"hi Normal ctermbg=none
