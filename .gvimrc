"--------------------------------------------------
" 表示/display
"--------------------------------------------------
" 背景色
"set background=dark
" カラースキーム
let s:home_vim = expand('~/.vim')
let s:colors_dir = s:home_vim . '/colors'
if !isdirectory(s:colors_dir)
    call mkdir(s:colors_dir, 'p')
endif

if index(split(&runtimepath, ','), s:home_vim) == -1
    let &runtimepath .= ',' . s:home_vim
endif

let s:molokai_file = s:colors_dir . '/molokai.vim'
if !filereadable(s:molokai_file)
    if executable('curl')
        call system('curl -fsSL https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -o ' . shellescape(s:molokai_file))
    endif
endif

if filereadable(s:molokai_file)
    try
        colorscheme molokai
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme default
    endtry
else
    colorscheme default
endif
" highlight Normal ctermbg=none
" highlight NonText ctermbg=none
" highlight LineNr ctermbg=none
" highlight Folded ctermbg=none
" highlight EndOfBuffer ctermbg=none
" フォント
set guifont=Ricty\ Diminished:h10
" 行間
"set linespace=0

" ウィンドウの縦幅
set lines=100
" ウィンドウの横幅
set columns=300
" メニュー表示/非表示
set guioptions+=m
" ツール表示/非表示
set guioptions-=T
"--------------------------------------------------
" UI
"--------------------------------------------------
" 右クリックメニュー追加
noremenu <script><silent> PopUp.メニューを表示 :set guioptions+=m<cr>
noremenu <script><silent> PopUp.メニューを非表示 :set guioptions-=m<cr>
noremenu <script><silent> PopUp.ツールバーを表示 :set guioptions+=T<cr>
noremenu <script><silent> PopUp.ツールバーを非表示 :set guioptions-=T<cr>

"--------------------------------------------------
" Plug in (dein.vim)
"--------------------------------------------------
let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
    call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
    let s:dir = 'dein.vim'->fnamemodify(':p')
    if !(s:dir->isdirectory())
        let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
        if !(s:dir->isdirectory())
            if executable('curl')
                call system('curl -fsSL https://raw.githubusercontent.com/Shougo/dein.vim/master/README.md -o ' . shellescape($CACHE .. '/dein.tmp'))
            endif
            if executable('git')
                execute '!git clone https://github.com/Shougo/dein.vim' s:dir
            endif
        endif
    endif
    execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

let s:dein_base = '~/.cache/dein/'
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

execute 'set runtimepath+=' .. s:dein_src

if filereadable(s:dein_src . '/autoload/dein.vim')
    call dein#begin(s:dein_base)
    call dein#add(s:dein_src)
    call dein#add('tomasr/molokai')
    call dein#add('preservim/nerdtree')
    call dein#end()
endif

filetype indent plugin on

"" plugin installation check
"if dein#check_install()
"    call dein#install()
"endif

if has('syntax')
    syntax on
endif
