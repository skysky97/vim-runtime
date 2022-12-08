set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
" ensure_installed = "c", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
" ignore_install = { "javascript" }, -- List of parsers to ignore installing
" highlight = {
"   enable = false,              -- false will disable the whole extension
"   disable = { "" },  -- list of language that will be disabled
" },
" }
" EOF
