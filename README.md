# Neovim config

### External dependencies

#### Python dependencies (mandatory)

add the path to your python3 (you can get it with `which python3`) and you sould install the neovim dependency for python with `python3 -m pip install pynvim`

```bash
# add this to macos.vim
let g:python3_host_prog = '/usr/bin/python3'
```

#### Ruby dependency

```bash
gem install neovim
```


### Node dependencies

```bash
npm install -g yarn
npm install -g neovim
```

### Spectre plugin (find and replace function like vscode)

```bash
brew install gnu-sed
```

### Binaries for searching

```bash
# ripgrep Read more in: https://github.com/nvim-telescope/telescope-fzf-writer.nvim#exports
# fd Read more in: https://github.com/sharkdp/fd#installation
brew install fd ripgrep
```

### Usefull commands

Treesitter

```sh
# install language syntax highlighting
:TSInstall <lang>
```

```sh
# List language syntax highlighting availables
:TSInstallInfo
```

Language servers

```sh
# Show Language server manager, here you can update, install and remove many language servers
:LSPInstallInfo
```
