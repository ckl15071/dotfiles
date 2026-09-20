#!/bin/bash

# スクリプト自身の場所(curl | bash の場合は特定できないので空)
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/.git" ]; then
    # ローカルにクローン済みのリポジトリから実行された場合はそれを使う
    DOTPATH="$SCRIPT_DIR"
else
    # curl | bash などで実行された場合はクローンから始める
    DOTPATH=~/dotfiles
    if [ ! -d "$DOTPATH/.git" ]; then
        git clone --recursive "https://github.com/ckl15071/dotfiles.git" "$DOTPATH"
    fi
fi

cd "$DOTPATH"

BACKUP_DIR=~/dotfiles_backup_$(date +%Y%m%d%H%M%S)

for f in .??*
do
    [ "$f" = ".git" ] && continue

    # 既存の実体ファイル/ディレクトリ(シンボリックリンク以外)をバックアップ
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        mkdir -p "$BACKUP_DIR"
        mv -v "$HOME/$f" "$BACKUP_DIR/$f"
    fi

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

