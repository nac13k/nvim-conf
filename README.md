# NVIM config

First at all you need to clone this repository and move to `$HOME/.config/nvim`

```bash
git clone https://github.com/nac13k/nvim-conf
mv ./nvim-conf $HOME/.config/nvim

```

Before to open neovim please install the `package manager` [packer](https://github.com/wbthomason/packer.nvim)

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

```

Now you can open the `init.lua` file and sync the plugins running this command (please be sure to supply all the [external dependencies](#external-dependencies)):

```bash
nvim $HOME/.config/nvim/init.lua

```

Once nvim is open run this command to sync the packages and restart nvim
```vim
:PackerSync

```

### Shortcuts

|        name       |    mode  |    keymap   | description |
| ----------------- | -------- | ----------- | ----------- |
| ShortcutFinder    | `normal` | `;m`        | Open a float window with all the shortcut configured, you can find any by the shortcut or the command to execute |
| FileProjectFinder | `normal` | `;f`        | Open a float window with all the files in the project excluding folders like (`node_modules`, `.git`, `.cache`, etc..), in this finder you can find by file name and ther relative path in the project |
| FileInFile        | `normal` | `;r`        | Open a float window where you can find text in all the project files, the match result will list above the finder input and the file content at the right |
| MarkdownPreview   | `normal` | `<Space>mp` | In an open `markdown` file this shorcut will open (or close, 'cause it's a toggle function) a live preview in your default browser |

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
npm install -g neovim
```

### Lspsaga dependencies

```vimscript
:TSInstall markdown
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
