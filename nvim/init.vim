set nocompatible
filetype off

call plug#begin('~/.config/nvim/plug')

Plug 'gmarik/Vundle.vim'

" Ricing
Plug 'dylanaraps/wal.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" General Use
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tmhedberg/SimpylFold'
Plug 'psliwka/vim-smoothie'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Rust
Plug 'rust-lang/rust.vim'

" Scss
Plug 'cakebaker/scss-syntax.vim'

" Python
Plug 'vim-scripts/indentpython.vim'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'Vimjas/vim-python-pep8-indent'

" Linting / Auto Completion
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Denite
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/denite.nvim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" All of your Plugins must be added before the following line
call plug#end()
filetype plugin indent on


" ============================================================================ "
" ===                          PACKER SETUP                                === "
" ============================================================================ "
lua <<EOF
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
end)
EOF


" ============================================================================ "
" ===                               GENERAL                                === "
" ============================================================================ "

" Remap leader key to ,
let g:mapleader=','

" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable spellcheck for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" Bind ESC to turn off highlighting
nnoremap <silent> <esc> :noh<cr><esc>

" Folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

set number
set background=dark
colorscheme wal
let g:airline_theme='wal'
set mouse=a
set laststatus=2
set noshowmode
set encoding=utf-8
set termguicolors

" Cursor shape
set guicursor=v-sm:block,i-ci-ve:ver25,n-c-r-cr-o:hor20

" Set persistent undo file
set undofile
set undodir=$HOME/.vim/undo

" Ensure cursor is centered
set scrolloff=20

" Copy Paste
set clipboard=unnamed

" ============================================================================ "
" ===                              FORMATTING                              === "
" ============================================================================ "
autocmd BufRead,BufNewFile *.js,*.ts,*.htm,*.html,*.css,*.scss setlocal ts=2 sw=2 sts=2 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
set tw=88
set autoindent



" ============================================================================ "
" ===                          INDENT BLANKLINE                            === "
" ============================================================================ "
lua <<EOF
require("indent_blankline").setup {}
EOF

let g:indent_blankline_char = "│"
let g:indent_blankline_filetype_exclude = [
	\ 'startify', 'dashboard', 'dotooagenda', 'log', 'fugitive', 'gitcommit',
	\ 'packer', 'vimwiki', 'markdown', 'json', 'txt', 'vista', 'help',
	\ 'todoist', 'NvimTree', 'peekaboo', 'git', 'TelescopePrompt', 'undotree',
	\ 'flutterToolsOutline', '' 
\ ]
let g:indent_blankline_buftype_exclude = ["terminal", "nofile"]
let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_context_patterns = [
	\ 'import', 'class_definition', 'function_definition',
	\ 'parenthesized_expression', 'argument_list', 'parameters', 'assignment',
	\ 'dictionary', 'list', 'tuple', 'set',
	\ 'for_statement', 'if_statement', 'with_statement', 'try_statement', 'while_statement'
\ ]
autocmd CursorMoved * IndentBlanklineRefresh

" ============================================================================ "
" ===                              NERD TREE                               === "
" ============================================================================ "

" let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
" map <C-n> :NERDTreeToggle<CR>
" nmap <leader>f :NERDTreeFind<CR>


" ============================================================================ "
" ===                              NVIM TREE                               === "
" ============================================================================ "
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache', '\.pyc']
let g:nvim_tree_git_hl = 1
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 0,
    \ 'folder_arrows': 1,
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


" ============================================================================ "
" ===                                OCAML                                 === "
" ============================================================================ "
set rtp^="/home/eamon/.opam/4.05.0/share/ocp-indent/vim"
au BufEnter *.ml setf ocaml
au BufEnter *.mli setf ocaml
au FileType ocaml call FT_ocaml()
function FT_ocaml()
    set textwidth=80
    set shiftwidth=2
    set tabstop=2
    " ocp-indent with ocp-indent-vim
    let opamshare=system("opam config var share | tr -d '\n'")
    execute "autocmd FileType ocaml source".opamshare."/ocp-indent/vim/indent/ocaml.vim"
    filetype indent on
    filetype plugin indent on
endfunction

" ============================================================================ "
" ===                              ALE SETUP                               === "
" ============================================================================ "
" let g:ale_linters = {
"       \   'python': ['flake8', 'pylint'],
"       \}
"
let g:ale_linters = {'python': []}
" let g:ale_fixers = {
"       \    'python': ['yapf'],
"       \    '*': ['remove_trailing_lines', 'trim_whitespace']
"       \}
let g:ale_fixers = {
      \    'python': ['remove_trailing_lines', 'trim_whitespace'],
      \    'javascript': ['remove_trailing_lines', 'trim_whitespace']
      \}
let g:ale_fix_on_save = 1

" Flake8 Options
let g:ale_python_flake8_options = '--ignore=E402'

" ============================================================================ "
" ===                              COC SETUP                               === "
" ============================================================================ "
set cmdheight=2
set updatetime=300
set signcolumn=number
"   <leader>dd    - Jump to definition of current symbol
"   <leader>dr    - Jump to references of current symbol
"   <leader>dj    - Jump to implementation of current symbol
"   <leader>ds    - Fuzzy search current project symbols
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cr <Plug>(coc-references)
nnoremap <silent> <leader>cs :<C-u>CocList -I -N --top symbols<CR>
nmap <leader>crr <Plug>(coc-rename)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>h <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>l <Plug>(coc-diagnostic-next)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" ============================================================================ "
" ===                           DENITE SETUP                               === "
" ============================================================================ "
" UNUSED

"" === Denite setup ==="
"" Use ripgrep for searching current directory for files
"" By default, ripgrep will respect rules in .gitignore
""   --files: Print each file that would be searched (but don't search)
""   --glob:  Include or exclues files for searching that match the given glob
""            (aka ignore .git files)
""
"call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

"" Use ripgrep in place of "grep"
"call denite#custom#var('grep', 'command', ['rg'])

"" Custom options for ripgrep
""   --vimgrep:  Show results with every match on it's own line
""   --hidden:   Search hidden directories and files
""   --heading:  Show the file name above clusters of matches from each file
""   --S:        Search case insensitively if the pattern is all lowercase
"call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

"" Recommended defaults for ripgrep via Denite docs
"call denite#custom#var('grep', 'recursive_opts', [])
"call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
"call denite#custom#var('grep', 'separator', ['--'])
"call denite#custom#var('grep', 'final_opts', [])

"" Remove date from buffer list
"call denite#custom#var('buffer', 'date_format', '')

"" Custom options for Denite
""   split                       - Use floating window for Denite
""   start_filter                - Start filtering on default
""   auto_resize                 - Auto resize the Denite window height automatically.
""   source_names                - Use short long names if multiple sources
""   prompt                      - Customize denite prompt
""   highlight_matched_char      - Matched characters highlight
""   highlight_matched_range     - matched range highlight
""   highlight_window_background - Change background group in floating window
""   highlight_filter_background - Change background group in floating filter window
""   winrow                      - Set Denite filter window to top
""   vertical_preview            - Open the preview window vertically

"let s:denite_options = {'default' : {
"\ 'split': 'floating',
"\ 'start_filter': 1,
"\ 'auto_resize': 1,
"\ 'source_names': 'short',
"\ 'prompt': 'λ ',
"\ 'highlight_matched_char': 'QuickFixLine',
"\ 'highlight_matched_range': 'Visual',
"\ 'highlight_window_background': 'Visual',
"\ 'highlight_filter_background': 'DiffAdd',
"\ 'winrow': 1,
"\ 'vertical_preview': 1
"\ }}

"" Loop through denite options and enable them
"function! s:profile(opts) abort
"  for l:fname in keys(a:opts)
"    for l:dopt in keys(a:opts[l:fname])
"      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
"    endfor
"  endfor
"endfunction

"" === Denite shorcuts === "
""   ;         - Browser currently open buffers
""   <leader>t - Browse list of files in current directory
""   <leader>g - Search current directory for occurences of given term and close window if no results
""   <leader>j - Search current directory for occurences of word under cursor
"nmap <leader>; :Denite buffer -start_filter<CR>
"nmap <leader>t :DeniteProjectDir file/rec -start_filter<CR>
"nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
"nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

"" Define mappings while in 'filter' mode
""   <C-o>         - Switch to normal mode inside of search results
""   <Esc>         - Exit denite window in any mode
""   <CR>          - Open currently selected file in any mode
""   <C-t>         - Open currently selected file in a new tab
""   <C-v>         - Open currently selected file a vertical split
""   <C-h>         - Open currently selected file in a horizontal split
"autocmd FileType denite-filter call s:denite_filter_my_settings()
"function! s:denite_filter_my_settings() abort
"  imap <silent><buffer> <ESC>
"  \ <Plug>(denite_filter_update)
"  inoremap <silent><buffer><expr> <CR>
"  \ denite#do_map('do_action')
"  inoremap <silent><buffer><expr> <C-t>
"  \ denite#do_map('do_action', 'tabopen')
"  inoremap <silent><buffer><expr> <C-v>
"  \ denite#do_map('do_action', 'vsplit')
"  inoremap <silent><buffer><expr> <C-h>
"  \ denite#do_map('do_action', 'split')
"endfunction

"" Define mappings while in denite window
""   <CR>        - Opens currently selected file
""   q or <Esc>  - Quit Denite window
""   d           - Delete currenly selected file
""   p           - Preview currently selected file
""   <C-o> or i  - Switch to insert mode inside of filter prompt
""   <C-t>       - Open currently selected file in a new tab
""   <C-v>       - Open currently selected file a vertical split
""   <C-h>       - Open currently selected file in a horizontal split
"autocmd FileType denite call s:denite_my_settings()
"function! s:denite_my_settings() abort
"  nnoremap <silent><buffer><expr> <CR>
"  \ denite#do_map('do_action')
"  nnoremap <silent><buffer><expr> o
"  \ denite#do_map('do_action')
"  nnoremap <silent><buffer><expr> q
"  \ denite#do_map('quit')
"  nnoremap <silent><buffer><expr> <Esc>
"  \ denite#do_map('quit')
"  nnoremap <silent><buffer><expr> d
"  \ denite#do_map('do_action', 'delete')
"  nnoremap <silent><buffer><expr> p
"  \ denite#do_map('do_action', 'preview')
"  nnoremap <silent><buffer><expr> i
"  \ denite#do_map('open_filter_buffer')
"  nnoremap <silent><buffer><expr> <C-o>
"  \ denite#do_map('open_filter_buffer')
"  nnoremap <silent><buffer><expr> <C-t>
"  \ denite#do_map('do_action', 'tabopen')
"  nnoremap <silent><buffer><expr> <C-v>
"  \ denite#do_map('do_action', 'vsplit')
"  nnoremap <silent><buffer><expr> <C-h>
"  \ denite#do_map('do_action', 'split')
"endfunction

" ============================================================================ "
" ===                         TREE SITTER SETUP                            === "
" ============================================================================ "

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   highlight = {
"     enable = true,
"     custom_captures = {
"       -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
"       -- ["foo.bar"] = "Identifier",
"     },
"     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
"     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
"     -- Using this option may slow down your editor, and you may see some duplicate highlights.
"     -- Instead of true it can also be a list of languages
"     additional_vim_regex_highlighting = false,
"   },
" }
" EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-v>",
      node_incremental = "<C-v>",
      node_decremental = "<C-e>",
    },
  },
}
EOF

lua <<EOF
require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
EOF

"
" ============================================================================ "
" ===                           TELESCOPE SETUP                            === "
" ============================================================================ "
nnoremap <leader>t <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>; <cmd>Telescope buffers<cr>

lua <<EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF
