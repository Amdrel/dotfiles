set nocompatible

filetype plugin indent on
syntax on

" Fix crappy Mac OS X defaults.
set backspace=indent,eol,start

set mouse-=a
set laststatus=2
set tabstop=4
set shiftwidth=4
set scrolloff=3
set colorcolumn=80,100,120

" Get rid of lag for exiting visual mode.
set timeoutlen=1000
set ttimeoutlen=0

" Complete options (disable preview scratch window).
set completeopt=menu,menuone

set hlsearch
set expandtab
set nu
set relativenumber
set autoindent
set autoread
set nowrap
set title
set cursorline

" Wildmenu creates a tab menu similar to fish and zsh. Also add some
" additional rules for case insensitivity.
set wildmenu
set noignorecase
set infercase

" Optimizations, useful for large files with multiple syntax highlighters.
set ttyfast
set lazyredraw

if !exists('g:vscode')
  " Window management key mappings so there's no need to press C-W to switch
  " buffers. C-hjkl can be used to switch between buffers with these mappings.
  nmap <silent> <C-h> :wincmd h<CR>
  nmap <silent> <C-j> :wincmd j<CR>
  nmap <silent> <C-k> :wincmd k<CR>
  nmap <silent> <C-l> :wincmd l<CR>

  " Keep selection when reindenting blocks of selected text.
  xnoremap < <gv
  xnoremap > >gv
else
  " vscode-neovim rebinds 'gq' to VSCode's code formatting feature for some
  " reason. I prefer to have it work the same was as it does in vanilla vim.
  " unmap gq
endif

" Vim distribution specific configurations.
if has('nvim')
  let g:prog_name = "neovim"

  " Provide an easy way to escape the terminal.
  tnoremap <C-X> <C-\><C-n>

  " Sakura and iTerm2 uses C-H for backspace since they are sane terminals.
  " Let's map it to move to left window.
  nmap <BS> <C-W>h

  " Change cursor to line cursor while in insert mode. Neovim has first class
  " support for this and may work with more terminals.
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

  " Fix terrible hard to read cursor color.
  hi MatchParen guifg=#F8F8F0 guibg=#444444 gui=bold
else
  let g:prog_name = "vim"
endif

" Setup clipboard to work on linux, bsds, and darwin.
if has("unix")
  let os=substitute(system('uname'), '\n', '', '')

  if os == 'Darwin' || os == 'Mac'
    set clipboard=unnamed
  elseif os == 'Linux' || os == 'FreeBSD' || os == 'OpenBSD' || os == 'NetBSD'
    set clipboard=unnamedplus
  endif
elseif executable('win32yank.exe') == 1
  set clipboard=unnamedplus

  let g:clipboard = {
  \   'name': 'win32yank',
  \   'copy': {
  \     '+': 'win32yank.exe -i --crlf',
  \     '*': 'win32yank.exe -i --crlf',
  \   },
  \   'paste': {
  \     '+': 'win32yank.exe -o --lf',
  \     '*': 'win32yank.exe -o --lf',
  \   },
  \   'cache_enabled': 0,
  \ }
endif

set background=dark
colorscheme lunaperche

" Generates a title for the window based on the context of the current buffer.
function! GetTitle()
  let buffer_name = expand("%:t")

  if len(buffer_name) <= 0
    return g:prog_name
  else
    return buffer_name . " - " . g:prog_name
  endif
endfunction
autocmd BufEnter * let &titlestring = GetTitle()

" Override some theme defaults to make vim more pleasing to the eye.
function! SetHighlights()
  highlight Normal ctermbg=234
  highlight clear CursorLine
  highlight CursorLine ctermbg=236
  highlight ColorColumn ctermbg=236
endfunction
autocmd VimEnter * call SetHighlights()
call SetHighlights()
