set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///Users/ricky/ansible/'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
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

set laststatus=2  " Always show statusline

set encoding=utf-8
set fileencodings=utf-8,cp950
syntax on "語法上色顯示
set ai "自動縮排
set shiftwidth=4 "設定縮排寬度4
set expandtab "用 space 代替 tab
set ruler "顯示右下角參數,如第幾行第幾個字
set backspace=2 "在 insert 也可用 backspace
set ic "設定搜尋忽略大小寫
set hlsearch "設定高亮度顯示搜尋結果
set incsearch "在關鍵字還沒完全輸入完畢前就顯示結果
set smartindent "設定 smartindent
set confirm "操作過程有衝突時，以明確的文字來詢問
set history=200 "保留 200 個使用過的指令
set cursorline "顯示目前的游標位置
set number "顯示行數
:nohl "搜尋不會有底色
:set nowrap "字串太長不自動換行
set cindent "自動縮排
set tabstop=4 "tab換成幾個空格
filetype indent on
colorscheme torte "個人喜好顏色配置
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
