" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle
set nocompatible  " be iMproved, required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'dense-analysis/ale'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ekalinin/Dockerfile.vim'
Bundle 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-fugitive'
Bundle 'lepture/vim-jinja'
"Bundle 'tbastos/vim-lua'
"Plugin 'chr4/nginx.vim'
Bundle 'spacewander/openresty-vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///etc/ansible/'
call vundle#end()            " required
filetype plugin on    " required
"filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

autocmd BufNewFile,BufRead Vagrantfile* set filetype=ruby
autocmd BufNewFile,BufRead Dockerfile* set filetype=Dockerfile
autocmd BufNewFile,BufRead */nginx/*.conf,*/nginx/*/*.conf,*/nginx/*/*/*.conf set filetype=nginx
autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=yaml
autocmd BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.j2 setfiletype jinja
augroup ansible_vim_fthosts
    autocmd!
    autocmd BufNewFile,BufRead */ansible/* setfiletype yaml.ansible
augroup END

"colorscheme torte "desert
"filetype off      " required
set backspace=2 backspace=indent,eol,start
set cindent smartindent autoindent
set confirm
set cursorcolumn
"highlight CursorColumn cterm=none ctermbg=DarkMagenta ctermfg=White
set cursorline
"highlight CursorLine cterm=none ctermbg=DarkMagenta ctermfg=White
set encoding=utf-8 fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
set expandtab tabstop=2 softtabstop=2 shiftwidth=2
set history=200
set hlsearch incsearch ic
set laststatus=2  ruler "Always show statusline
"set mouse=a
"set mouse=nv " 只在 Normal 以及 Visual 模式使用滑鼠，也就是取消 Insert 模式的滑鼠
set wrap "nowrap
"set number
"set undodir=~/.vim/.undo// "结尾的//表示生成的文件名带有绝对路径，路径中用%替换目录分隔符，这样可以防止文件重名
"set undofile
set t_Co=256
set wildmenu wildmode=longest:list,full
syntax on
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
