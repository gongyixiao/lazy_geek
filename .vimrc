set backspace=2     " backspace in insert mode works like normal editor
syntax on           " enable syntax highlighting
filetype indent on  " activates indenting for files
set autoindent      " enable auto indenting
colorscheme desert  " better colorscheme
set nobackup        " get rid of ~file backups
set pastetoggle=<F2>

" Load a YAML syntax coloring script that works better
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
