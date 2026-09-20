#!/bin/bash
# VSCode のユーザー設定を適用するスクリプト
# 使い方:
#   ローカル実行: bash install_vscode.sh
#   リモート実行: curl -L raw.githubusercontent.com/ckl15071/dotfiles/master/install_vscode.sh | bash

# スクリプト自身の場所（curl | bash の場合は特定できないので空）
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# 設定ファイルの場所を決定
if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/Code/User" ]; then
    # ローカルにクローン済みのリポジトリから実行された場合はそれを使う
    SRC_DIR="$SCRIPT_DIR/Code/User"
else
    # curl | bash などで実行された場合はクローンから始める
    DOTPATH=~/dotfiles
    if [ ! -d "$DOTPATH/.git" ]; then
        git clone --recursive "https://github.com/ckl15071/dotfiles.git" "$DOTPATH"
    fi
    SRC_DIR="$DOTPATH/Code/User"
fi

# 配置先の VSCode ユーザーディレクトリをOSごとに決定
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        TARGET_DIR="$HOME/AppData/Roaming/Code/User"
        ;;
    Darwin*)
        TARGET_DIR="$HOME/Library/Application Support/Code/User"
        ;;
    Linux*)
        TARGET_DIR="$HOME/.config/Code/User"
        ;;
    *)
        echo "Error: unsupported OS ($(uname -s))" >&2
        exit 1
        ;;
esac

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: $SRC_DIR が見つかりません" >&2
    exit 1
fi

echo "Source: $SRC_DIR"
echo "Target: $TARGET_DIR"

BACKUP_DIR="$TARGET_DIR/backup/$(date +%Y%m%d_%H%M%S)"

# old/ フォルダ以外の全ファイルを再帰的に処理
find "$SRC_DIR" -type f ! -path "*/old/*" | while read -r src; do
    # SRC_DIR からの相対パスを取得
    rel_path="${src#$SRC_DIR/}"
    dst="$TARGET_DIR/$rel_path"

    # 既存の実体ファイル（シンボリックリンク以外）をバックアップ
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$rel_path")"
        mv -v "$dst" "$BACKUP_DIR/$rel_path"
    fi

    mkdir -p "$(dirname "$dst")"
    cp -v "$src" "$dst"
done

echo "Done. VSCode を再起動すると設定が反映されます。"
