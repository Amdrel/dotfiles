call pathogen#infect()
call pathogen#helptags()

" Screw compatibility, that's not hip and kewl.
set nocompatible

" Required Vundle setup.
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Valloric/MatchTagAlways'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'Valloric/YouCompleteMe'
Bundle 'mileszs/ack.vim'
Bundle 'jiangmiao/auto-pairs'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'nanotech/jellybeans.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'alvan/vim-closetag'
Bundle 'flazz/vim-colorschemes'
Bundle 'tpope/vim-fugitive'
Bundle 'quabug/vim-gdscript'
Bundle 'w0ng/vim-hybrid'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'tpope/vim-sleuth'

filetype plugin indent on
syntax on

" Setup powerline statusline. It's pretty...
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

" Fix crappy Mac OS X defaults.
set backspace=indent,eol,start

set laststatus=2

set nu
set autoindent
set autoread
set nowrap
set cursorline
set wildmenu

" Change cursor to line cursor while in insert mode.
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Allow auto indenting on these usually blacklisted tags. This means that only
" the <html> tag should not indent.
let g:html_indent_inctags="body,head,tbody"

" 80 columns by default.
set colorcolumn=80,100,120

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

" Fix GDScript highlighting.
au BufNewFile,BufRead *.gd set filetype=gdscript

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

let g:closetag_filenames = "*.html,*.xhtml,*.phtml"

" Turn off all jellybeans background colours
" ------------------------------------------

" where turning off background colors would leave the text invisible
" on a dark background I've used the background color picked by jellybeans
" for the the foreground.
"
" NOTE:
"	Setting the background of StatusLine and StatusLineNC to none
"	seems to result in a bug in which the space of the status line
"	is filled with carets- very annoying!
"
let g:jellybeans_overrides = {
\	'Normal': {
\		'256ctermbg': 'none',
\	}
\}

let g:jellybeans_background_color_256="none"
let g:jellybeans_use_lowcolor_black = 0

" Fancy colors fancy time!
set background=dark
colorscheme hybrid
hi Normal ctermbg=none

"set background=dark
"hi ColorColumn ctermbg=234 ctermfg=234
