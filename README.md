# dotfiles

## インストール

```bash
# ローカルから実行
cd ~/dotfiles
bash install.sh

# リモートから実行（初回セットアップ時など）
curl -L raw.githubusercontent.com/ckl15071/dotfiles/master/install.sh | bash
```

## VSCode の設定

VSCode のユーザー設定を適用する。

```bash
# ローカルから実行
cd ~/dotfiles
bash install_vscode.sh

# リモートから実行（初回セットアップ時など）
curl -L raw.githubusercontent.com/ckl15071/dotfiles/master/install_vscode.sh | bash
```

## バックアップ

install.sh / install_vscode.sh で上書きされる既存ファイルは、
実行日付ごとのフォルダに退避される。

- install.sh: `~/dotfiles_backup/YYYYMMDD_hhmmss/`
- install_vscode.sh: VSCode 設定フォルダ内の `backup/YYYYMMDD_hhmmss/`
  - Windows: `~/AppData/Roaming/Code/User/backup/...`
  - macOS: `~/Library/Application Support/Code/User/backup/...`
  - Linux: `~/.config/Code/User/backup/...`
