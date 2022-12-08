# vim

Config for vim and neovim.

## Install

1. Make a symlink or copy of `vim` folder in home directory.

   ```sh
   cd ~
   ln -s <path>/vim .vim
   ```

2. Run `PlugInstall` command in vim to install vim plugins.

3. Run `CocInstall` command in vim to install coc.nvim based plugins.

4. Additionally copy neovim config files if you use neovim.

   ```sh
   cd ~/.config/nvim/
   ln -s <path>/vim/init.vim
   ln -s <path>/vim/coc-settings.json
   ```

## About plugins

Using `coc.nvim` to provide most features like lsp support, file lists, project
search and explorer.
