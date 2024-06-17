" Name:     vim configuration
" Author:   skysky97 <skysky97@126.com>
" URL:      https://github.com/skysky97/vim-runtime

" Generic {{{
" ----------------------------------------------------------------------------
let g:vim_home=$HOME.'/.vim'
" Info: Set nocompatible before everything, cause it affects other options.
set nocompatible
" Empty viminfo to avoid keep history, like jumplist
set viminfo=""        
set encoding=utf-8
set hidden
set updatetime=300
set ttimeoutlen=5
set nobackup
set nowritebackup
set wildmenu
set mouse=a
set nrformats=bin,octal,hex,alpha
set smartcase
set incsearch
set ttyfast
set sidescroll=1
set splitbelow
set splitright
set nostartofline
" Create cache directory to store swp files.
call mkdir($HOME . "/.local/share/vim/swap", 'p')
" Set cache directory, '//' means include folders into swap file name which
" avoid file name conflict.
set directory=~/.local/share/vim/swap//

" }}}
" Editor {{{
" ----------------------------------------------------------------------------
set nowrap
set linebreak
set breakindent
set smartindent
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set formatoptions-=ro

" }}}
" Appearance {{{
" ----------------------------------------------------------------------------
set signcolumn=number
set number
set laststatus=2
set cmdheight=1
set ruler
set showtabline=2
if has('patch-8.2.0750')
set wildoptions=pum
endif
set hlsearch
set textwidth=0
set colorcolumn=+1
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" }}}
" Highlight {{{
" ----------------------------------------------------------------------------
" Info: The color scheme should be set after plugin loaded. So it is not set
" here, but in the Colorscheme section.
syntax enable
set background=dark

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


" }}}
" Statusline {{{
" ----------------------------------------------------------------------------
" Info: 
"  - statusline expression should not contain space, use '\ ' for space.
"  - use '%=" to add a seperator.

" left: filename, modified flag, readonly flag, left align 
"       Needs tagbar plugin to show current tag.
set statusline=%-.71(%t%m%r%)
set statusline+=%{exists('tagbar#currenttag')?tagbar#currenttag('\ ▶\ %s','','','nearest-stl'):''}

" middle left: git branch
set statusline+=%=
set statusline+=%{get(g:,'coc_git_status','')} " git status

" middle right: empty
set statusline+=%=

" right: line, column, percentage, fileencoding, fileformat, filetype
set statusline+=%=
set statusline+=\ %l,%c
set statusline+=\ %p%%
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %{&fileformat}
set statusline+=\ %y

" }}}
" FileType {{{
" ----------------------------------------------------------------------------
autocmd FileType cpp setlocal commentstring=//\ %s

" }}}
" Key mappings {{{
" ----------------------------------------------------------------------------
nnoremap <Space> <Nop>
nmap <silent> <Space><Space><Space> :set wrap!<CR>
" Search
nmap <silent> <C-l> :nohlsearch<CR>
" Config
nmap <silent> <leader>oc :e ~/.vim/vimrc<CR>
nmap <silent> <leader>os :e 
    \ ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim<CR>
" Copy & Paste
nmap <S-p> "+p
vmap <S-y> "+y
" Navigation
nmap <silent> gn :bprev<CR>
nmap <silent> gp :bnext<CR>
nmap <silent> gl :b#<CR>

nmap <Space>B :buffers<CR>:buffer

" Show location list
nmap <silent><Space>l :lopen 15<CR>
nmap <silent><Space>q :copen 15<CR>
nmap <F3> :lp<CR>
nmap <F4> :lne<CR>
nmap <Space>ff :lvim 
nmap <Space>fa :lvim 
nmap <silent><Space>fw :exec 'lvim /'.expand('<cword>').'/j %'<CR>:lopen 15<CR>
nmap <silent><Space>fW :exec 'lvimgrepa /'.expand('<cword>').'/j %'<CR>:lopen 15<CR>

function! s:setup_quickfix_window()
    " map <Esc> to close window
    nnoremap <buffer><Esc> <C-w>c
endfunction

autocmd FileType qf call <SID>setup_quickfix_window()
autocmd WinLeave * if (&buftype == 'quickfix') | :lclose | endif

" CMake
nmap gmk :term cmake -B build -DCMAKE_BUILD_TYPE=Debug<CR>
nmap gmb :term cmake --build build<CR>
nmap gmi :term cmake --install build<CR>
nmap gmc :term ++close rm -rf build<CR>

" }}}
" Netrw {{{
" ----------------------------------------------------------------------------
let g:netrw_banner=0
let g:netrw_liststyle=3 " tree
let g:netrw_wiw=60
" Show vim builtin explorer netrw.
nmap <nowait><leader>e :35Lexplore<CR>

function! s:replace_word(confirm)
    let string=input('Replace "'.expand('<cword>').'" with:')
    if a:confirm
        exe '%s/\<'.expand('<cword>').'\>/'.string.'/gc'
    else
        exe '%s/\<'.expand('<cword>').'\>/'.string.'/g'
    endif
endfunction
nmap <leader>rr :call <SID>replace_word(1)<CR>
nmap <leader>RR :call <SID>replace_word(0)<CR>

" }}}
" Zen {{{
" ----------------------------------------------------------------------------
let s:zen_mod=0
nmap <silent>gz :call <SID>SwitchZenMode()<CR>
function! s:SwitchZenMode()                                                            
    if &number
        set nonumber
        set signcolumn=no
    else
        set number
        set signcolumn=number
    endif
endfun

" }}}
" Terminal {{{
" ----------------------------------------------------------------------------
" Open new terminal.
nmap <leader>t :term 
nmap <nowait><C-`> <Plug>(coc-terminal-toggle) 
tmap <C-`> <Plug>(coc-terminal-toggle) 
" }}}
" Termdebug {{{
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
" Compatible {{{
" ----------------------------------------------------------------------------
" Fix terminal compatibility issue.
let &t_ut=''

" }}}
" Plugin {{{
" ----------------------------------------------------------------------------
call plug#begin(g:vim_home.'/plugged')
Plug 'skysky97/vim-colors-solarized'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'github/copilot.vim'
Plug 'preservim/tagbar'
Plug 'hotoo/pangu.vim'

" CLOSED plugins:
" ---------------
" Plug 'cdelledonne/vim-cmake'
" Plug 'easymotion/vim-easymotion'
" Plug 'kevinoid/vim-jsonc'
" Plug 'frazrepo/vim-rainbow'
" Plug 'voldikss/vim-translator'
" Plug 'vim-scripts/DrawIt'
" Plug 'vim-scripts/AnsiEsc.vim'
" Plug 'powerman/vim-plugin-AnsiEsc'
" Plug 'valloric/vim-operator-highlight'
" Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'skywind3000/asynctasks.vim'
" Plug 'skywind3000/asyncrun.vim'
" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" if has('nvim-0.6.0')
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" endif
call plug#end()

" }}}
" Colorscheme {{{
" ----------------------------------------------------------------------------
" Info: The color scheme should be set after plugin loaded.
" Check if solarized color scheme exists.
if isdirectory(g:vim_home.'/plugged/vim-colors-solarized')
  colorscheme solarized
else
  colorscheme habamax
endif

" }}}
" solarized {{{
" ----------------------------------------------------------------------------
" Solarized options.
" let g:solarized_termcolors=16
" let g:solarized_termtrans=0
" let g:solarized_truecolors=1

" }}}
" coc.nvim {{{
" ----------------------------------------------------------------------------
" let g:node_client_debug = 1
let g:coc_disable_startup_warning = 1

" Set coc mappings only when the plugin is enabled.
" Using VimEnter cmd here to make sure the mappings are set after coc.nvim is
" loaded, as some mappings may override the default mappings and if coc is not
" enabled then the default mappings should be used.
autocmd VimEnter * call s:coc_map_key()

" Function to map keys for coc.nvim
function s:coc_map_key()
  if !exists('g:coc_enabled') || !g:coc_enabled
    return
  endif
  if exists('g:coc_key_map_enabled') && g:coc_key_map_enabled
    return
  endif
  let g:coc_key_map_enabled = 1

  " Goto definition
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Switch source header file. Needs coc-clangd.
  nmap <silent> gf :CocCommand clangd.switchSourceHeader<CR>
  nmap <silent> gh :call <SID>show_documentation()<CR>

  " CocList pre/next
  nnoremap <silent><nowait> <C-j> :<C-u>CocNext<CR>
  nnoremap <silent><nowait> <C-k> :<C-u>CocPrev<CR>

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
endfunction

" Show documentation in preview window.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" let g:coc_global_extensions = [
"   \"coc-clangd",
"   \"coc-cmake",
"   \"coc-explorer",
"   \"coc-git",
"   \"coc-highlight",
"   \"coc-java",
"   \"coc-jedi",
"   \"coc-json",
"   \"coc-lists",
"   \"coc-marketplace",
"   \"coc-rls",
"   \"coc-sh",
"   \"coc-snippets",
"   \"coc-todolist",
"   \"coc-tsserver",
"   \"coc-ultisnips",
"   \"coc-vimlsp",
"   \"coc-word",
"   \"coc-xml",
"   \"coc-tasks",
"   \"coc-prettier",
"   \]

" coc-selection
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

nmap <silent> <leader>a <Plug>(coc-cursors-position)

" coc-completion
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

inoremap <silent><expr> <S-TAB>
  \ coc#pum#visible() ? coc#_select_confirm() : "\<TAB>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" use ctrl+l for trigger completion
inoremap <silent><expr> <c-l> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" coc-refactor 
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

" }}}
" coc-list {{{
" ----------------------------------------------------------------------------
" Show previous opened list.
nmap <silent><nowait> <Space>p :<C-u>CocListResume<CR>
nmap <Space><Space>a :<C-u>CocListResume grep<CR>
nmap <Space><Space>g :<C-u>CocListResume location<CR>
nmap <Space><Space>p :<C-u>CocListResume files<CR>
nmap <Space><Space>m :<C-u>CocListResume mru<CR>

" Show diagnostics list.
nmap <Space>d :CocList --regex diagnostics --buffer<CR>
nmap <Space>D :CocList --regex diagnostics<CR>

" Show command list.
nmap <Space>c :CocCommand<CR>
" List project files.
nmap <C-p> :CocList files<CR>

" List recent opened files.
nmap <Space>m :CocList mru<CR>

" List buffers.
nmap <Space>b :CocList buffers<CR>

" Search semantic symbol under cursor.
nmap <Space>s :exe 'CocList -I --input='.expand('<cword>').' symbols'<CR>

" Search semantic symbol.
nmap <Space>S :CocList -I symbols<CR>

" Search word under cursor in current buffer.
nmap <Space>/ :exe 'CocList -I --input='.expand('<cword>').' words'<CR>

" Search word under cursor in cwd or workspace.
nmap <Space>w :exe 'CocList -I --input='.expand('<cword>').' grep -w'<CR>

" Search pattern using regex expressions in cwd or workspace.
nmap <Space>a :CocList -I grep -e<CR>

" Show outline window.
nmap <Space>o :CocList outline<CR>

" }}}
" coc-explorer {{{
" ----------------------------------------------------------------------------
" Show explorer window.
nmap <Space>e :CocCommand explorer --width 60 --quit-on-open<CR>
nmap <Space>E :CocCommand explorer --width 200 --quit-on-open<CR>

" }}}
" coc-git {{{
" ----------------------------------------------------------------------------
" navigate chunks of current buffer
nmap <leader>hk <Plug>(coc-git-prevchunk)
nmap <leader>hj <Plug>(coc-git-nextchunk)
nmap <leader>hu :CocCommand git.chunkUndo<CR>
nmap <leader>hs :CocCommand git.chunkStage<CR>
nmap <leader>hS :CocCommand git.chunkUnstage<CR>
nmap <leader>hi <Plug>(coc-git-chunkinfo)
" navigate conflicts of current buffer
" nmap gK <Plug>(coc-git-prevconflict)
" nmap gJ <Plug>(coc-git-nextconflict)
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

nmap <Space>gl :CocList bcommits<CR>
nmap <Space>gL :CocList commits<CR>
nmap <Space>gs :CocList gstatus<CR>
nmap <Space>gi :CocList gchunks<CR>
nmap <Space>gI :CocList gchanges<CR>
nmap <Space>gb :CocList branches<CR>

nmap gb <Plug>(coc-git-showblamedoc)
nmap gi <Plug>(coc-git-chunkinfo)
nmap gI <Plug>(coc-git-commit)

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
" Pangu  {{{
" ----------------------------------------------------------------------------
" Format using Pangu.
nmap <leader>fP :PanguAll<CR>
xmap <leader>fP :Pangu<CR>

" Pangu format option
" let g:pangu_punctuation_brackets = ["「", "」"]
let g:pangu_punctuation_brackets = ["『", "』"]
let g:pangu_rule_date = 0 " no space between date and time
let g:pangu_rule_spacing = 0 " no add space between Chinese and English

" }}}
" task {{{
" ----------------------------------------------------------------------------
nmap <Space>t :CocList tasks<CR>

" }}}
" translator {{{
" ----------------------------------------------------------------------------
let g:translator_target_lang = 'zh'
let g:translator_default_engines=['bing', 'haici']
nmap <space>r <Plug>TranslateW  
vmap <space>r <Plug>TranslateWV

" }}}
" tagbar {{{
" ----------------------------------------------------------------------------
nmap gH :TagbarCurrentTag fp nearest-stl<CR>

" }}}
" whihc-key {{{
" ----------------------------------------------------------------------------
nmap <silent><space> :WhichKey '<Space>'<CR>

" }}}
" copilot {{{
" ----------------------------------------------------------------------------
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-CR> copilot#Accept("")
imap <silent><C-L> <Plug>(copilot-accept-word)
imap <silent><C-J> <Plug>(copilot-next)
imap <silent><C-/> <Plug>(copilot-suggest)
" }}}
" End  {{{
" ----------------------------------------------------------------------------
" vim:foldmethod=marker:foldlevel=0

" }}}
