if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PLUGINS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

call plug#begin('~/.vim/pluggers')

  Plug 'junegunn/vim-plug'               " The current plugin manager

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ FILES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'francoiscabrol/ranger.vim'       "File manager
  Plug 'junegunn/fzf.vim'                "Fuzzy wuzzy was a finder
  Plug '/usr/local/opt/fzf'              " You'll have to install fzf if you don't have it, but I really recommend it,
                                         " it's super fast and very useful for a ton of different things
                                         " on mac $ brew install fzf

  "Plug '~/.fzf'                         " on ubuntu $ sudo apt-get install fzf
                                         " on anything else using git $ git clone --depth 1

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ MAGIC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ LANGUAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'Zaptic/elm-vim'
  Plug 'chrisbra/Colorizer'
  Plug 'elixir-editors/vim-elixir'
  Plug 'leafgarland/typescript-vim'
  Plug 'ianks/vim-tsx'
  Plug 'pangloss/vim-javascript'

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ STATUS BAR ~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'vim-airline/vim-airline'         " Uncomment if you want a status bar

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ THEME ~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'mhinz/vim-startify'
  Plug 'ajmwagar/vim-deus'

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ TIPPY TAPPY ~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'Raimondi/delimitMate'            " autocompletion of closing tags
  Plug 'Yggdroot/indentLine'             " Display Indentation
  Plug 'tpope/vim-surround'              " Surround text with text
  Plug 'tpope/vim-commentary'            " All Hail Tpope
  Plug 'michaeljsmith/vim-indent-object' " Another default vscode vim plugin for indentation levels as text objects
  " Plug 'tpope/vim-endwise'

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ GIT GUD ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Plug 'airblade/vim-gitgutter'          " Show changes to repo in sidebar

  "~~~~~~~~~~~~~~~~~~~~~~~~~~~ MARKUP LANGUAGE ~~~~~~~~~~~~~~~~~~~~~

  Plug 'mattn/emmet-vim'                 " Super nice plugin for html stuff

call plug#end()

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if &runtimepath =~ 'startify'
  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:startify_lists = [{ 'type': 'dir', 'header': ['MRU'.  getcwd()] }]
  let g:ascii = [
        \"   ▄▄▄██▀▀▀██▓ ███▄ ▄███▓",
        \"     ▒██  ▓██▒▓██▒▀█▀ ██▒",
        \"     ░██  ▒██▒▓██    ▓██░",
        \"  ▓██▄██▓ ░██░▒██    ▒██",
        \"   ▓███▒  ░██░▒██▒   ░██▒",
        \"   ▒▓▒▒░  ░▓  ░ ▒░   ░  ░",
        \"  ▒ ░▒░   ▒ ░░  ░      ░",
        \"   ░ ░ ░   ▒ ░░      ░",
        \"   ░   ░   ░         ░"   
        \]

  let g:startify_custom_header = g:ascii
endif

if &runtimepath =~ 'elm-vim'
  let g:elm_setup_keybindings = 0
endif

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ COC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if &runtimepath =~ 'coc'

  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> gh :call CocAction('doHover')<Cr>
  nmap <leader>rn <Plug>(coc-rename)
  nmap <silent> gy <Plug>(coc-type-definition)
  let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-rls',
  \'coc-marketplace', 'coc-elixir', 'coc-tsserver', 'coc-eslint',
  \'coc-prettier']
  nmap <silent> gd <Plug>(coc-definition)
endif

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FIND ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" This is some default config for fzf to behave similarly to
" spacevim/ctrlP/Vscode stuff
if &runtimepath =~ 'fzf.vim'
  " set rtp+=/usr/local/opt/fzf
  let g:fzf_buffers_jump = 1
  nnoremap <silent> <Leader>p :Files<CR>
  nnoremap <silent> <Leader>b :Buffers<CR>
  nnoremap <silent> <Leader>G :Lines<CR>
  nnoremap <silent> <Leader>c :Commits<CR>
  " note: THERE'S SOME WHITESPACE AT THE END OF \/THIS\/ LINE AND IT'S INTENTIONAL 
  nnoremap <silent> <Leader>F :Rg 
  nnoremap <silent> <Leader>C :Colors<CR>
  " These two are pretty nice, they just give you a nice searchable list of
  " all commands and mappings
  nnoremap <silent> <Leader>: :Commands<CR>
  nnoremap <silent> <Leader><Leader><Leader> :Maps<CR>
  " preview for files
  " Can also be used in a similar way to set up previews of most lists
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)

  if has('nvim')
    let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
    function! FloatingFZF()
      let width = float2nr(&columns * 0.9)
      let height = float2nr(&lines * 0.6)
      let opts = { 'relative': 'editor',
                 \ 'row': (&lines - height) / 2,
                 \ 'col': (&columns - width) / 2,
                 \ 'width': width,
                 \ 'height': height }
      let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
      call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
    endfunction
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  endif
endif

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FILES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if &runtimepath =~ 'ranger'
  let g:ranger_replace_netrw = 1
  let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
endif

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ RICE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if &runtimepath =~ 'vim-deus'
  colorscheme deus
  if exists('$TMUX')
    hi Normal guibg=NONE
  endif
endif

