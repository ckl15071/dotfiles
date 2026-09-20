#!/bin/bash
# VSCode のユーザー設定を適用するスクリプト
# 使い方: bash install_vscode.sh

# スクリプト自身の場所を基準にする（どこから実行してもOK）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/VSCode"

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

# "リポジトリ内のパス:配置先のパス" の対応表
# 注意: c_cpp_properties.json はユーザー設定ではなくワークスペース
#       (.vscode/) 用のファイルなのでここでは対象外
FILES=(
    "settings.json:settings.json"
    "keybindings.json:keybindings.json"
)

for entry in "${FILES[@]}"; do
    src="$SRC_DIR/${entry%%:*}"
    dst="$TARGET_DIR/${entry##*:}"

    if [ ! -f "$src" ]; then
        echo "Skip: $src が見つかりません"
        continue
    fi

    # 既存の実体ファイル（シンボリックリンク以外）をバックアップ
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        mv -v "$dst" "$BACKUP_DIR/$(basename "$dst")"
    fi

    mkdir -p "$(dirname "$dst")"
    cp -v "$src" "$dst"
done

echo "Done. VSCode を再起動すると設定が反映されます。"
