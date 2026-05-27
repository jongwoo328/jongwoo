#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Error: this script only supports macOS (detected: $(uname -s))." >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# starship: ~/.zshrc의 eval "$(starship init zsh)" 때문에 없으면 셸 실행마다 에러 → 필수
if ! command -v starship >/dev/null 2>&1; then
    echo "Error: 'starship' is required (this script adds 'eval \"\$(starship init zsh)\"' to ~/.zshrc)." >&2
    echo "Install it: brew install starship" >&2
    command -v brew >/dev/null 2>&1 || echo "(brew not installed? https://brew.sh)" >&2
    exit 1
fi

# nvim / lsd: 없어도 셸은 정상 동작 (lsd는 command -v 가드, nvim은 EDITOR env만 set) → 경고만
for tool in nvim lsd; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Warning: '$tool' not installed (install: brew install $tool)." >&2
    fi
done

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
    # 파일이 개행 없이 끝나면 새 줄이 마지막 줄에 붙어버리므로 개행을 먼저 추가
    if [ -f "$file" ] && [ -n "$(tail -c1 "$file" 2>/dev/null || true)" ]; then
        echo "" >> "$file"
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
