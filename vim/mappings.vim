let mapleader = " "

" remaps for the sake of civility
nnoremap ; :

" Easier window motions
nnoremap <Leader>j <C-W><C-J>
nnoremap <Leader>k <C-W><C-K>
nnoremap <Leader>l <C-W><C-L>
nnoremap <Leader>h <C-W><C-H>

" I usually prefer the arrow keys
nnoremap <Leader>J <C-W>J
nnoremap <Leader>K <C-W>K
nnoremap <Leader>H <C-W>H
nnoremap <Leader>L <C-W>L

" We don't need no stinkin arrows
nnoremap <Up> :res +5<Cr>
nnoremap <Down> :res -5<Cr>
nnoremap <Left> :vertical resize -5<Cr>
nnoremap <Right> :vertical resize +5<Cr>

" Easy window creation
nnoremap <Leader>w<Leader>l :vsp<CR>
nnoremap <Leader>w<Leader>j :sp<CR>

" Circular window nav
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
