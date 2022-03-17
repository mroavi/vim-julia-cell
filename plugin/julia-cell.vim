" File:         julia-cell.vim
" Description:  Execute Julia code cells in a REPL inside a tmux pane directly from Vim.

if exists('g:loaded_julia_cell')
    finish
endif
let g:loaded_julia_cell = 1

if !has("python") && !has("python3")
    echo 'julia-cell requires py >= 2.7 or py3'
    finish
endif

let g:julia_cell_delimit_cells_by = get(g:, 'julia_cell_delimit_cells_by', 'marks')
let g:julia_cell_tag = get(g:, 'julia_cell_tag', '##')
let g:julia_cell_valid_marks = get(g:, 'julia_cell_valid_marks', 'abcdefghijklmnopqrstuvqxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

function! s:UsingPython3()
  if has('python3')
    return 1
  endif
    return 0
endfunction

if !exists('g:julia_cell_cmd')
	let g:julia_cell_cmd="include_string(Main, clipboard())"
endif

if !exists('g:julia_cell_use_primary_selection')
	let g:julia_cell_use_primary_selection=0
endif

let s:using_python3 = s:UsingPython3()
let s:python_until_eof = s:using_python3 ? "python3 << EOF" : "python << EOF"
let s:python_command = s:using_python3 ? "py3 " : "py "

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

exec s:python_until_eof
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import julia_cell
EOF

function! JuliaCellClear()
    exec s:python_command "julia_cell.clear()"
endfunction

function! JuliaCellExecuteCell(...)
    let arg1 = get(a:, 1, 0)
    let arg2 = get(a:, 2, 0)
    exec s:python_command "julia_cell.execute_cell()"
    if arg2
        exec s:python_command "julia_cell.jump_next_cell()"
    endif
endfunction

function! JuliaCellNextCell()
    exec s:python_command "julia_cell.jump_next_cell()"
endfunction

function! JuliaCellPrevCell()
    exec s:python_command "julia_cell.jump_prev_cell()"
endfunction

function! JuliaCellRun()
    exec s:python_command "julia_cell.run()"
endfunction

command! -nargs=0 JuliaCellClear call JuliaCellClear()
command! -nargs=0 JuliaCellExecuteCell call JuliaCellExecuteCell()
command! -nargs=0 JuliaCellExecuteCellJump call JuliaCellExecuteCell(1, 1)
command! -nargs=0 JuliaCellNextCell call JuliaCellNextCell()
command! -nargs=0 JuliaCellPrevCell call JuliaCellPrevCell()
command! -nargs=0 JuliaCellRun call JuliaCellRun()
