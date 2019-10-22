function! SourceFile(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceFile("~/.vim/settings.vim")
call SourceFile("~/.vim/mappings.vim")
call SourceFile("~/.vim/plugins.vim")
" if has('nvim')
"  call SourceFile("~/.vim/settings/nvim_settings.vim")
" endif
