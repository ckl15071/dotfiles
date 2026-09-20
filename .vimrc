scriptencoding utf-8

"==================================================
" 基本設定
"==================================================
" エンコード設定
set encoding=utf-8
" 保存時の文字コード
set fileencoding=utf-8
" 読み込み時の文字コード自動判別(左側から優先)
set fileencodings=utf-8,ucs-bom,cp932,sjis,euc-jp
" 改行コードの自動判別(左側から優先)
set fileformats=unix,dos,mac
" 全角半角
set ambiwidth=double

" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden

"==================================================
" プラグインマネージャ起動
"==================================================

"==================================================
" プラグインごとのグローバル変数
"==================================================
" 閉じタグ自動補完対象ファイル
let g:closetag_filenames = '*.html, *php'
" Emmet用キー
let g:user_emmet_leader_key='<c-s>'

" netrw
" netrw上部のバナーを表示しない
let g:netrw_banner = 0
" netrwのウィンドウサイズ（-30：列幅30文字固定）
let g:netrw_winsize = -30
let g:netrw_liststyle = 3
" Lexplore は常に左側に開く
let g:netrw_altv = 0
" 起動時に左側に開く
"autocmd VimEnter * Lexplore
" プレビューウィンドウ
let g:netrw_preview = 1 " 1：垂直分割

"==================================================
" 検索・編集・移動の基本挙動
"==================================================
" コマンドラインの保管
"
set wildmode=list:longest
" コマンドモードの補完
set wildmenu
" :findで現在のフォルダ以下を再帰検索する
set path+=**
" 入力中のコマンドをステータスに表示する
set showcmd

if has('gui') || has('xterm_clipboard')
    "無名レジスタのデータを*レジスタにも入れる（yank内容をクリップボードと共有）
    set clipboard+=unnamed
endif

" タブを半角スペースに
set expandtab
let _curfile=expand("%:t")
" Makefileはタブ使用
if _curfile == ('Makefile')
    set noexpandtab
endif
" スマートインデント
set smartindent
" 行末の1文字先までカーソル移動
"set virtualedit=onemore
" 矩形選択のブロック化（文字のないところにカーソル移動できるようにする）
"set virtualedit=block

" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan
" リアルタイム検索
set incsearch
" 検索結果をハイライト表示
set hlsearch
" 行をまたいで移動
"set whichwrap=b,s,h,l,<,>,[,],~
set backspace=indent,eol,start

"==================================================
" 外観
"==================================================
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の列を強調表示
set nocursorcolumn
" 空白文字の可視化
set list
set listchars=tab:\-\>,eol:$,trail:*,space:.

" 色変更
highlight NonText ctermfg=21 guifg=#0000ff
" ビープ音・警告表示を可視化しない
set noerrorbells
set visualbell t_vb=
set belloff=all
" 長い行の表示
set display=lastline
" タブ幅
set tabstop=4
" インデント幅
set shiftwidth=4

" ターミナルのタイトルをセットする
set title

" ステータスライン設定
" ステータスライン表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示、2:常に表示)
set laststatus=2
" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" 文字コード
set statusline+=[%{&fileencoding}]
" 改行コード
if &fileformat == ('unix')
    set statusline+=[LF]
elseif &fileformat == ('dos')
    set statusline+=[CRLF]
elseif &fileformat == ('mac')
    set statusline+=[CR]
endif
" 現在行数/全行数
set statusline+=[%l/%L]

" 色変更と可視化に関する補助表示
" 全角スペースの可視化
" colorscheme が未読み込みでも group を定義しておき、E411 を防ぐ
highlight default IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
" matchadd は GUI/CLI の起動順序差があるため避ける
"augroup highlightIdegraphicSpace
"    autocmd!
"    autocmd VimEnter,WinEnter * call matchadd('IdeographicSpace', '　')
"augroup END

"==================================================
" カラースキーム準備
"==================================================
let s:home_vim = expand('~/.vim')
let s:colors_dir = s:home_vim . '/colors'
if !isdirectory(s:colors_dir)
    call mkdir(s:colors_dir, 'p')
endif

" Vim の探索経路にホーム側の colors 置き場を追加
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

"==================================================
" キーマップ
"==================================================
nnoremap ; :
nnoremap : ;
nnoremap <Esc><Esc> :noh<CR>

"==================================================
" 関数・Autocmd
"==================================================
" netrwの表示状態に応じて、エクスプローラを開く／閉じる
function! ToggleLexplore()
    " Netrwバッファが存在する場合はエクスプローラを閉じる
    if bufexists('Netrw')
        execute 'Lexplore!'
    " Netrwバッファがない場合はエクスプローラを開く
    else
        execute 'Lexplore'
    endif

    " 分割されているウィンドウを等幅にする
    wincmd =
endfunction

" ファイルを閉じてnetrwだけが残った場合に、netrwも閉じる
function! s:CloseNetrwIfAlone() abort
    " ウィンドウが1つだけで、その内容がnetrwなら閉じる
    if winnr('$') == 1 && &filetype ==# 'netrw'
        quit
    endif
endfunction

augroup netrw_auto_close
    autocmd!
    " ファイルを閉じてnetrwに戻ったタイミングで、netrwも閉じる
    autocmd WinEnter * call <SID>CloseNetrwIfAlone()
augroup END

augroup gvim_dnd_dir_cd
  autocmd!
  " バッファに入ったとき、それがディレクトリ（フォルダ）ならそこへcdする
  autocmd BufEnter * if isdirectory(expand('%:p')) | execute 'cd' fnameescape(expand('%:p')) | endif
augroup END

nnoremap <silent> <C-b> :call ToggleLexplore()<CR>

" 個別のタブインデント幅設定
autocmd BufRead,BufNewFile *.php setlocal tabstop=2 shiftwidth=2

"==================================================
" 構文ハイライト
"==================================================
syntax on
set t_Co=256
