let g:python3_host_prog='/usr/bin/python3'
" Install Plugin
call plug#begin('~/.vim/plugged')

Plug 'vim-jp/vimdoc-ja'
Plug 'junegunn/fzf', {'dir': '~/.fzf_bin', 'do': './install --all'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/gina.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sainnhe/gruvbox-material'
Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'thinca/vim-quickrun'
Plug 'machakann/vim-sandwich'
Plug 'jiangmiao/auto-pairs'
Plug 'zakj/vim-showmarks'
Plug 'rust-lang/rust.vim'

call plug#end()

" #############################################################
" ######################## set options ########################
" #############################################################

" ######################## Appearance #########################
set termguicolors
set title
set number
set wrap
set showmatch
set matchtime=2
set pumheight=10
set display=lastline
set cursorline
set hidden
set foldmethod=syntax
set foldlevel=7

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

if has('gui_running')
	set guioptions-=a guioptions-=i
	set guioptions-=r guioptions-=L
	set guioptions-=e guioptions-=m guioptions+=M guioptions-=t guioptions-=T guioptions-=g
	set guioptions+=c
	set guifont=FixedSys:h11
endif

" ########################### Search ##########################
set ignorecase
set smartcase
set wrapscan
set hlsearch

" ########################### Indent ##########################
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" ######################## Completion #########################
set wildmode=full
set infercase
set wildmenu

" ######################### Operation #########################
set backspace=indent,eol,start
set hidden
set textwidth=0

" ########################## Logging ##########################
set history=5000
set noswapfile
set noundofile
set nobackup
set nowritebackup
set viminfo=

" ########################## Others ###########################
syntax enable
filetype plugin indent on
set encoding=utf-8
set fileencodings=utf-8,cp932

autocmd QuickFixCmdPost make,*grep* cwindow
autocmd FileType * setlocal formatoptions-=ro

" Rust settings
autocmd BufNewFile,BufRead *.rs :compiler cargo
let g:rustfmt_autosave=1

" #############################################################
" ####################### Key Mappings ########################
" #############################################################

" ######################## Map Prefix #########################
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

" ##################### Window Operation ######################
nnoremap <silent> <Leader>v :vs<CR>
nnoremap <silent> <Leader>s :sp<CR>
nnoremap <silent> <Leader>h <C-w>h
nnoremap <silent> <Leader>j <C-w>j
nnoremap <silent> <Leader>k <C-w>k
nnoremap <silent> <Leader>l <C-w>l

" ######################## Completion #########################
nnoremap <c-]> g<c-]>
nnoremap ' `
nnoremap ` ' 

nnoremap Y y$

nnoremap <F5> :e $MYVIMRC<CR>
nnoremap <F6> :so $MYVIMRC<CR>

" ###################### Settings for Coc #######################
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-eslint8', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy :<C-u>CocCommand fzf-preview.CocTypeDefinition<CR>
nnoremap <silent> gi :<C-u>CocCommand fzf-preview.CocImplementations<CR>
nnoremap <silent> gr :<C-u>CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent> go :<C-u>CocCommand fzf-preview.CocOutline --add-fzf-arg=--exact --add-fzf-arg=--no-sort<CR>
nnoremap <silent> gq :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K       :<C-u>call <SID>show_documentation()<CR>

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap     <silent> <Leader>rn <Plug>(coc-rename)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
"" fzf-preview
let $BAT_THEME                     = 'gruvbox-dark'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'gruvbox-dark'

nnoremap <silent> <C-p>  :<C-u>CocCommand fzf-preview.FromResources buffer project_mru project<CR>
nnoremap <silent> zs  :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> zgg :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> zb  :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap          zf  :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>
xnoremap          zf  "sy:CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"

"" fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer<CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -reveal=%<CR>

" Edit contents of register
nnoremap <Leader>R :<C-u><C-r><C-r>='let @' . v:register . ' = ' .string(getreg(v:register))<CR><C-f><Left>

" Scroll
nnoremap <Leader><Space> <C-f>
nnoremap <Leader>b <C-b>

" #############################################################
" ###################### Other Settings #######################
" #############################################################

"" treesitter
if has('nvim')
lua <<EOF
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "typescript",
        "tsx",
        "c",
        "cpp",
        "haskell",
        "rust",
        "sql",
        "verilog",
      },
      highlight = {
        enable = true,
      },
    }
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.haskell = {
      install_info = {
        url = "~/path/to/tree-sitter-haskell",
        files = {"src/parser.c", "src/scanner.c"}
      }
    }
EOF
endif

"" gruvbox
colorscheme gruvbox-material
