if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/jimbo_jambos_jammin_plugins')
  " Plug 'dense-analysis/ale'            " Uncomment if you want live linting

  " Plug 'vim-airline/vim-airline'       " Uncomment if you want a status bar

  Plug 'junegunn/vim-plug'               " The current plugin manager
                                         " https://github.com/junegunn/vim-plug

  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'} " extensions can do a lot of what you can do in vscode
                                         " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#why-are-coc-extensions-needed


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

  Plug 'sainnhe/vim-color-forest-night'


call plug#end()

if &runtimepath =~ 'startify'
  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
endif

if &runtimepath =~ 'coc'

  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

  " This is pretty great and is very VSCode-y
  nnoremap <silent> K :call <SID>show_documentation()<CR> 

  " definition jumping for Coc
  " Not sure if you want these
  "nmap <silent> gd <Plug>(coc-definition)
  "nmap <silent> gy <Plug>(coc-type-definition)
  "nmap <silent> gi <Plug>(coc-implementation)
  "nmap <silent> gr <Plug>(coc-references)
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
  let g:polyglot_disabled = ['markdown', 'fish', 'json', 'rails', 'ruby'] "Some of these are just so slow
endif

if &runtimepath =~ 'forest-night'
  colorscheme forest-night 
  if exists('$TMUX')
    hi Normal guibg=NONE
  endif
endif
