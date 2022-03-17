julia-cell
============

Cell support for Julia in Vim.

![Demo animation](../assets/vim-julia-cell-demo.gif?raw=true)


Requirements
------------

This plugin requires Vim/Neovim with Python 2 or Python 3 support (`+python` or `+python3` when running `vim --version`).

julia-cell uses [vim-slime](https://github.com/jpalardy/vim-slime) to send code to the Julia REPL.

The cell execution feature requires a clipboard program to be installed. [xclip](https://github.com/astrand/xclip) and [xsel](https://github.com/kfish/xsel) are supported on Linux, and pbcopy on macOS. Windows is not supported.

If [vim-highlightedyank](https://github.com/machakann/vim-highlightedyank) is installed, code sent to the REPL is highlighted.

Installation
------------

Install vim-slime and julia-cell using your favorite package manager:

#### Using [vim-plug](https://github.com/junegunn/vim-plug)

~~~vim
Plug 'jpalardy/vim-slime'
Plug 'mroavi/vim-julia-cell', { 'for': 'julia' }
~~~


#### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

~~~vim
Plugin 'jpalardy/vim-slime'
Plugin 'mroavi/vim-julia-cell'
~~~


Usage
-----

julia-cell sends code from Vim to a Julia REPL using [vim-slime](https://github.com/jpalardy/vim-slime). This means that Julia has to be running in a terminal multiplexer like GNU Screen or tmux, or in a Vim/Neovim terminal.

Code cells are defined by either Vim marks or tags in the code, depending on the value of `g:julia_cell_delimit_cells_by`. 

This plugin does not define any key mappings by default. See the [Example Vim Configuration](#example-vim-configuration) section below for examples of how to set them to the available commands.

Note that the cell execution feature copies your code to the system clipboard, which may be undesirable if your code contains sensitive data.


### Commands

| Command | Description |
| --- | --- |
| `:JuliaCellExecuteCell` | Execute the current code cell. |
| `:JuliaCellExecuteCellJump` | Execute the current code cell and jump to the next cell. |
| `:JuliaCellRun` | Run the entire file. |
| `:JuliaCellClear` | Clear the REPL. |
| `:JuliaCellPrevCell` | Jump to the previous cell header. |
| `:JuliaCellNextCell` | Jump to the next cell header. |


### Configuration

| Option| Description | Default |
| --- | ---| --- |
| `g:julia_cell_delimit_cells_by`| Specifies if cells are delimited by `'marks'` or `'tags'`. | `'marks'` |
| `g:julia_cell_tag`  | Specifies the tag format. | `'##'` |
| `g:julia_cell_cmd`  | Specifies the exact command. | `'include_string(Main, clipboard())'` |

eg:  
You can add
```julia
macro paste()
	include_string(Main, read(pipeline(`xclip -quiet -out -selection`, stderr=stderr), String));
end
```
into `~/.julia/config/startup.jl` and `let g:julia_cell_cmd='@paste'` to use X11 primary selection

### Example

Example of how to configure julia-cell in your `.vimrc`.

~~~vim
" Load plugins using vim-plug
call plug#begin('~/.vim/plugged')
Plug 'jpalardy/vim-slime'
Plug 'mroavi/vim-julia-cell', { 'for': 'julia' }
call plug#end()

"------------------------------------------------------------------------------
" slime configuration 
"------------------------------------------------------------------------------
let g:slime_target = 'tmux'
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" julia-cell configuration
"------------------------------------------------------------------------------
" Use '##' tags to define cells
let g:julia_cell_delimit_cells_by = 'tags'

" map <Leader>jr to run entire file
nnoremap <Leader>jr :JuliaCellRun<CR>

" map <Leader>jc to execute the current cell
nnoremap <Leader>jc :JuliaCellExecuteCell<CR>

" map <Leader>jC to execute the current cell and jump to the next cell
nnoremap <Leader>jC :JuliaCellExecuteCellJump<CR>

" map <Leader>jl to clear Julia screen
nnoremap <Leader>jl :JuliaCellClear<CR>

" map <Leader>jp and <Leader>jn to jump to the previous and next cell header
nnoremap <Leader>jp :JuliaCellPrevCell<CR>
nnoremap <Leader>jn :JuliaCellNextCell<CR>

" map <Leader>je to execute the current line or current selection
nmap <Leader>je <Plug>SlimeLineSend
xmap <Leader>je <Plug>SlimeRegionSend

~~~

In case you want to save before running the entire file:

~~~vim
" map <F5> to save and run script
nnoremap <F5> :w<CR>:JuliaCellRun<CR>

~~~


Credits
------

- julia-cell is and adaptation of [hanschen/vim-ipython-cell](https://github.com/hanschen/vim-ipython-cell).
- This plugin uses [vim-slime](https://github.com/jpalardy/vim-slime) under the hood to communicate with the Julia REPL. 
- @FirstnameLastname came up with an initial implementation.
