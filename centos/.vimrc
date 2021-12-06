" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle
set nocompatible  " be iMproved, required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ekalinin/Dockerfile.vim'
Bundle 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-fugitive'
Bundle 'lepture/vim-jinja'
Bundle 'spacewander/openresty-vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'file:///home/vagrant/'
call vundle#end()            " required
filetype plugin on    " required
autocmd BufNewFile,BufRead Vagrantfile* set filetype=ruby
autocmd BufNewFile,BufRead Dockerfile* set filetype=Dockerfile
autocmd BufNewFile,BufRead */nginx/*.conf,*/nginx/*/*.conf,*/nginx/*/*/*.conf set filetype=nginx
autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=yaml
autocmd BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.j2 setfiletype jinja
augroup ansible_vim_fthosts
    autocmd!
    autocmd BufNewFile,BufRead */ansible/* setfiletype yaml.ansible
augroup END
set backspace=2 backspace=indent,eol,start
set cindent smartindent autoindent
set confirm
set cursorcolumn
set cursorline
set encoding=utf-8 fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
set expandtab tabstop=2 softtabstop=2 shiftwidth=2
set history=200
set hlsearch incsearch ic
set laststatus=2  ruler "Always show statusline
set wrap "nowrap
set t_Co=256
set wildmenu wildmode=longest:list,full
syntax on
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
