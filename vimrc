" Name:     vim configuration
" Author:   liyunting<liyunting0919@outlook.com>
" URL:      https://github.com/skysky97/config

" Generic {{{
" ----------------------------------------------------------------------------
set encoding=utf-8
set hidden
set nocompatible
set updatetime=300
set nobackup
set nowritebackup
set wildoptions=pum
set wildmenu
set mouse=a
set ttimeoutlen=5
set nrformats=bin,octal,hex,alpha
set smartcase
set incsearch
set ttyfast
set sidescroll=1
set splitbelow
set splitright

set number
set signcolumn=number
set nowrap
set linebreak
set breakindent
set breakindentopt=shift:4
set smartindent
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set ruler
set showtabline=2
set laststatus=2
set cmdheight=1
set hlsearch
set textwidth=80
set colorcolumn=+1

autocmd FileType cpp setlocal commentstring=//%s

" Create cache directory to store swp files.
call mkdir($HOME . "/.cache/vim", 'p')
" Set cache directory, '//' means include folders into swap file name which
" avoid file name conflict.
set directory=~/.cache/vim//

" Mapping
nnoremap <Space> <Nop>
nmap <silent> <Space><Space> :set wrap!<CR>
nmap <silent> <leader>c :nohlsearch<CR>
nmap <silent> <leader>ec :e ~/.vim/vimrc<CR>
nmap <silent> <leader>es :e 
    \ ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim<CR>

" }}}
" Plugin {{{
" ----------------------------------------------------------------------------
call plug#begin()
Plug 'skysky97/vim-colors-solarized'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn --install --frozen-lockfile'}
Plug 'kevinoid/vim-jsonc'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
"Plug 'valloric/vim-operator-highlight'
"Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-scripts/DrawIt'
Plug 'voldikss/vim-translator'
if has('nvim-0.6.0')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif
" Plug 'hotoo/pangu.vim'
call plug#end()

" }}}
" Color & Theme {{{
" ----------------------------------------------------------------------------
" Vim supports using true colors in the terminal, given that the terminal
" supports this. To make this work the 'termguicolors' option needs to be set.
" Type ':h xterm-ture-color' for more details.
"
" FIXME: Some terminals support true colors but not set COLORTERM env.
if (has('termguicolors') && ($COLORTERM =~ 'truecolor'))
  set termguicolors
endif

" Enable builtin doxygen syntax highlight.
let g:load_doxygen_syntax=1
 
" Show syntax name under cursor. This helps debug highlihgt group.
nmap gS :call <SID>SynGroup()<CR>
function! s:SynGroup()                                                            
  let l:s = synID(line('.'), col('.'), 1)                                       
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Solarized options.
" let g:solarized_termcolors=16
" let g:solarized_termtrans=0
" let g:solarized_truecolors=1

syntax enable
set background=dark
colorscheme solarized

" }}}
" Navigation {{{
" ----------------------------------------------------------------------------
" Basic navigations.

nmap <silent> gn :bprev<CR>
nmap <silent> gp :bnext<CR>
nmap <silent> gl :b#<CR>

" coc.nvim goto.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> gf :CocCommand clangd.switchSourceHeader<CR>

" coc-lists pre/next
nnoremap <silent><nowait> <C-j> :<C-u>CocNext<CR>
nnoremap <silent><nowait> <C-k> :<C-u>CocPrev<CR>

" Show documentation in preview window.
nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
nnoremap <silent> gH : CocCommand clangd.inlayHints.toggle<CR>

" Scroll in float window.
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
nnoremap <silent><nowait><expr> <C-f>
  \ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b>
  \ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f>
  \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b>
  \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f>
  \ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b>
  \ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" }}}
" Search & Explore  {{{
" ----------------------------------------------------------------------------
" List project files.
nmap <C-p> :CocList files<CR>

" List recent opened files.
nmap <Space>m :CocList mru<CR>

" List buffers.
nmap <Space>b :CocList buffers<CR>
nmap <Space>B :buffers<CR>:buffer

" Search semantic symbol under cursor.
nmap <Space>s :exe 'CocList -I --input='.expand('<cword>').' symbols'<CR>

" Search semantic symbol.
nmap <Space>S :CocList -I symbols<CR>

" Search word under cursor in current buffer.
nmap <Space>/ :exe 'CocList -I --input='.expand('<cword>').' words'<CR>

" Search word under cursor in cwd or workspace.
nmap <Space>w :exe 'CocList -I --input='.expand('<cword>').' grep -w'<CR>

" Search word in cwd or workspace.
nmap <Space>W :CocList -I grep -w<CR>

" Search pattern using regex expressions in cwd or workspace.
nmap <Space>a :CocList -I grep -e<CR>

" Search word under cursor using regex expressions in cwd or workspace.
nmap <Space>A :exe 'CocList -I --input='.expand('<cword>').' grep -e'<CR>

" Show outline window.
nmap <Space>o :CocList outline<CR>

" Show explorer window.
nmap <Space>e :CocCommand explorer --width 60 --quit-on-open<CR>
nmap <Space>E :CocCommand explorer --width 200 --quit-on-open<CR>

" Show previous opened list.
nnoremap <silent><nowait> <Space>p :<C-u>CocListResume<CR>

" Show vim builtin explorer netrw.
nmap <leader>e :Explore<CR>

" Show diagnostics list.
nmap <Space>d :CocList diagnostics<CR>

" Show command list.
nmap <Space>c :CocCommand<CR>

" Show all coc lists
nmap <Space>l :CocList<CR>

" }}}
" Refactor  {{{
" ----------------------------------------------------------------------------
" Refactor using LSP.
nmap <leader>fw <plug>(coc-cursors-word)
xmap <leader>fw <plug>(coc-cursors-range)
nmap <leader>fR <plug>(coc-refactor)
nmap <leader>fr <plug>(coc-rename)
nmap <leader>ff <plug>(coc-format-selected)
xmap <leader>ff <plug>(coc-format-selected)
nmap <leader>fq <plug>(coc-fix-current)

" Format using prettier.
nmap <leader>fp :CocCommand prettier.formatFile<CR>

" Format using Pangu.
nmap <leader>fP :PanguAll

" Pangu format option
" let g:pangu_punctuation_brackets = ["「", "」"]
let g:pangu_punctuation_brackets = ["『", "』"]

" }}}
" Selection  {{{
" ----------------------------------------------------------------------------
" Select ranges using LSP.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Auto highlight cursor word.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" }}}
" Completion  {{{
" ----------------------------------------------------------------------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#_select_confirm() : 
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use ctrl+l for trigger completion
inoremap <silent><expr> <c-l> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" }}}
" Snippets {{{
" ----------------------------------------------------------------------------
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
"let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_next = '<tab>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" }}}
" esaymotion {{{
" ----------------------------------------------------------------------------
nmap gs <Plug>(easymotion-overwin-f)

" }}}
" coc.nvim {{{
" ----------------------------------------------------------------------------
let g:coc_global_extensions = [
  \"coc-clangd",
  \"coc-cmake",
  \"coc-explorer",
  \"coc-git",
  \"coc-highlight",
  \"coc-java",
  \"coc-jedi",
  \"coc-json",
  \"coc-lists",
  \"coc-marketplace",
  \"coc-rls",
  \"coc-sh",
  \"coc-snippets",
  \"coc-todolist",
  \"coc-tsserver",
  \"coc-ultisnips",
  \"coc-vimlsp",
  \"coc-word",
  \"coc-xml",
  \"coc-tasks",
  \"coc-prettier",
  \]

" }}}
" git {{{
" ----------------------------------------------------------------------------
" navigate chunks of current buffer
nmap <leader>hk <Plug>(coc-git-prevchunk)
nmap <leader>hj <Plug>(coc-git-nextchunk)
nmap <leader>hu :CocCommand git.chunkUndo<CR>
nmap <leader>hs :CocCommand git.chunkStage<CR>
nmap <leader>hS :CocCommand git.chunkUnstage<CR>
nmap <leader>hi <Plug>(coc-git-chunkinfo)
" navigate conflicts of current buffer
" nmap <leader>ck <Plug>(coc-git-prevconflict)
" nmap <leader>cj <Plug>(coc-git-nextconflict)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

nmap <Space>gl :CocList bcommits<CR>
nmap <Space>gL :CocList commits<CR>
nmap <Space>gs :CocList gstatus<CR>
nmap <Space>gi :CocList gchunks<CR>

nmap gb <Plug>(coc-git-showblamedoc)
nmap gi <Plug>(coc-git-chunkinfo)
nmap gI <Plug>(coc-git-commit)

" }}}
" terminal {{{
" ----------------------------------------------------------------------------
" Open new terminal.
nmap <leader>t :term<CR>
nmap <C-`> :term<CR>
tmap <C-`> :hide<CR>
" }}}
" termdebug {{{
" ----------------------------------------------------------------------------
nmap <silent> <leader>d :packadd termdebug<CR>:Termdebug<CR>
nmap <F5>       :Continue<CR>
nmap <F10>      :Over<CR>
nmap <F11>      :Step<CR>
nmap <F9>       :Break<CR>
nmap <S-F9>     :Clear<CR>
nmap <S-F5>     :Stop<CR>
nmap <C-S-F5>   :Run<CR>

" }}}
" task {{{
" ----------------------------------------------------------------------------
nmap <Space>t :CocList tasks<CR>

" }}}
" translator {{{
" ----------------------------------------------------------------------------
let g:translator_target_lang = 'zh'
let g:translator_default_engines=['bing', 'haici']
nmap <leader>r <Plug>TranslateW  
vmap <leader>r <Plug>TranslateWV

" }}}
" statusline {{{
" ----------------------------------------------------------------------------
let g:git_status_info=get(g:,'coc_git_status','')
if (strlen(g:git_status_info) > 12)
    let g:git_status_info=strpart(g:git_status_info, 0, 12)
endif
set statusline= 
set statusline+=\ %{get(g:,'git_status_info','')}
" set statusline+=\ %{get(b:,'coc_git_status','')}
" set statusline+=\ %{get(b:,'coc_git_blame','')}
" set statusline+=%#StatusLineFile#
set statusline+=\ %.70f
" set statusline+=%#StatusLineRight#
set statusline+=%m
set statusline+=%r
set statusline+=%=
set statusline+=\ %l:%c
set statusline+=\ %p%%
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %{&fileformat}
set statusline+=\ 

" }}}
" zen {{{
" ----------------------------------------------------------------------------
let s:zen_mod=0
nmap <silent>gz :call <SID>SwitchZenMode()<CR>
function! s:SwitchZenMode()                                                            
    if s:zen_mod
        set number
        set signcolumn=number
        let s:zen_mod=0
    else
        set nonumber
        set signcolumn=no
        let s:zen_mod=1
    endif
endfun

" }}}
" Compatible {{{
" ----------------------------------------------------------------------------
" Fix terminal compatibility issue.
let &t_ut=''

" }}}
" End  {{{
" ----------------------------------------------------------------------------
" vim:foldmethod=marker:foldlevel=0

" }}}
