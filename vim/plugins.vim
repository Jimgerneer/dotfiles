if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/jimbo_jambos_jammin_plugins')
  Plug 'vim-airline/vim-airline'       " Uncomment if you want a status bar

  Plug 'junegunn/vim-plug'               " The current plugin manager
                                         " https://github.com/junegunn/vim-plug

  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " Coc intellisense engine
                                         " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#why-are-coc-extensions-needed


  Plug 'francoiscabrol/ranger.vim'       "File manager
  Plug 'junegunn/fzf.vim'                    " https://github.com/junegunn/fzf
  Plug '/usr/local/opt/fzf'              " You'll have to install fzf if you don't have it, but I really recommend it,
                                         " it's super fast and very useful for a ton of different things
                                         " on mac $ brew install fzf

  "Plug '~/.fzf'                         " on ubuntu $ sudo apt-get install fzf
                                         " on anything else using git $ git clone --depth 1
                                         " https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install


  Plug 'Raimondi/delimitMate'            " autocompletion of closing tags
                                         " https://github.com/Raimondi/delimitMate

  Plug 'Yggdroot/indentLine'             " Display Indentation
                                         " https://github.com/Yggdroot/indentLine

  Plug 'airblade/vim-gitgutter'          " Show changes to repo in sidebar
                                         " https://github.com/airblade/vim-gitgutter

  Plug 'tpope/vim-surround'              " Surround text with text
                                         " https://github.com/tpope/vim-surround

  Plug 'tpope/vim-commentary'            " All Hail Tpope
                                         " https://github.com/tpope/vim-commentary

  Plug 'michaeljsmith/vim-indent-object' " Another default vscode vim plugin for indentation levels as text objects
                                         " https://github.com/michaeljsmith/vim-indent-object

  Plug 'mattn/emmet-vim'                 " Super nice plugin for html stuff
                                         " https://github.com/mattn/emmet-vim

                                         " Plug 'sheerun/vim-polyglot'            " autoloaded multiple language support (IT ALSO CAN BE SLOW WITH SOME TYPES OF FILES, WHICH IS WHY I COMMENTED IT OUT)
                                         " https://github.com/sheerun/vim-polyglot
  Plug 'mhinz/vim-startify'
  Plug 'sheerun/vim-polyglot'
  Plug 'gkapfham/vim-vitamin-onec'
  Plug 'tpope/vim-endwise'
  Plug 'leafgarland/typescript-vim'
  Plug 'ianks/vim-tsx'
  Plug 'dense-analysis/ale'



call plug#end()

if &runtimepath =~ 'startify'
  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
endif

"---------------ALE

if &runtimepath =~ 'ale'
  let g:ale_fixers = {
  \ 'typescript': ['prettier']
  \}
  let g:ale_fix_on_save = 1
  let g:ale_completion_tsserver_autoimport = 1
  nnoremap gd :ALEGoToDefinition<Cr>
  let g:ale_set_balloons = 1
  let g:ale_lint_delay = 50
endif

if &runtimepath =~ 'coc'

  " inoremap <silent><expr> <TAB>
  " \ pumvisible() ? coc#_select_confirm() :
  " \ coc#expandableOrJumpable() ?
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  " inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  "               " use <c-space> for trigger completion.
  "               inoremap <silent><expr> <c-space> coc#refresh()
  "               " rename current word
  "               nmap <leader>rn <Plug>(coc-rename)
  "               "use <tab> for trigger completion, completion confirm,
  "               snippet expand and jump
"                 coc#rpc#request('doKeymap',
"                 ['snippets-expand-jump','']) :
"                 \ <SID>check_back_space() ? "\<TAB>" :
"                 \ coc#refresh()
  
  "               " use <c-j> and <c-k> for selection options
  "               inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  "               inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
  "
  let g:coc_snippet_next = '<tab>'
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " This is pretty great and is very VSCode-y
  nnoremap <silent> K :call <SID>show_documentation()<CR> 

  " definition jumping for Coc
  " use coc for jumps
  " nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " " coc lint fix
  noremap <leader>lf <Plug>(coc-fix-current)
  "
  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>
endif
 
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
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
endif

" these can really get slow, especially ruby and rails
if &runtimepath =~ 'vim-polyglot'
  let g:polyglot_disabled = ['typescript', 'markdown', 'fish', 'json', 'rails', 'ruby'] "Some of these are just so slow
endif

if &runtimepath =~ 'ranger'
  let g:ranger_replace_netrw = 1
  let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
endif

if &runtimepath =~ 'vim-vitamin-onec'
  colorscheme vitaminonec
  if exists('$TMUX')
    hi Normal guibg=NONE
  endif
endif
