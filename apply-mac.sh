#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: this script only supports macOS (detected: $(uname -s))." >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

missing=""
for tool in starship nvim lsd; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        missing="$missing $tool"
    fi
done
if [ -n "$missing" ]; then
    echo "Error: required tools not installed:$missing" >&2
    echo "Install them, e.g.: brew install$missing" >&2
    command -v brew >/dev/null 2>&1 || echo "(brew not installed? https://brew.sh)" >&2
    exit 1
fi

link() {
    local src="$1"
    local dst="$2"
    if [ ! -e "$src" ]; then
        echo "Error: link source does not exist: $src" >&2
        exit 1
    fi
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "[skip]   $dst -> $src (already linked)"
        return
    fi
    if [ -L "$dst" ] || [ -e "$dst" ]; then
        local backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "[backup] $dst -> $backup"
        mv "$dst" "$backup"
    fi
    ln -s "$src" "$dst"
    echo "[link]   $dst -> $src"
}

add_line() {
    local line="$1"
    local file="$2"
    if [ -f "$file" ] && grep -Fxq "$line" "$file"; then
        echo "[skip]   $file already contains: $line"
        return
    fi
    printf '%s\n' "$line" >> "$file"
    echo "[append] $file: $line"
}

mkdir -p "$HOME/.config"

link "$REPO_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"
link "$REPO_DIR/zsh/zshrc_custom"  "$HOME/.zshrc_custom"

add_line '[ -f ~/.zshrc_custom ] && source ~/.zshrc_custom' "$HOME/.zshrc"
add_line 'eval "$(starship init zsh)"'                      "$HOME/.zshrc"

echo
echo "Done. Run 'exec zsh' to apply."
echo "Note: starship.toml uses Nerd Font glyphs. If the prompt looks broken,"
echo "      install one, e.g.: brew install --cask font-jetbrains-mono-nerd-font"
