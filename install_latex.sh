#!/usr/bin/env bash
# Cài môi trường LaTeX trên macOS: Homebrew + (MacTeX | BasicTeX | Tectonic) + VS Code extension
# Cách dùng:
#   chmod +x install_latex_macos.sh
#   ./install_latex_macos.sh            # mặc định: BasicTeX (nhẹ) + extension VS Code
#   ./install_latex_macos.sh full       # MacTeX đầy đủ (~5-6 GB)
#   ./install_latex_macos.sh basic      # BasicTeX + gói hay dùng cho paper
#   ./install_latex_macos.sh tectonic   # Tectonic (gọn, tự tải gói khi cần)

set -euo pipefail

MODE="${1:-basic}"

info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  error "Script này chỉ dành cho macOS."
  exit 1
fi

case "$MODE" in
  full|basic|tectonic) ;;
  *) error "Chế độ không hợp lệ: $MODE (dùng: full | basic | tectonic)"; exit 1 ;;
esac

# ---------- 1. Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  # Có thể đã cài nhưng chưa nằm trong PATH
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  info "Chưa có Homebrew, đang cài (cần mật khẩu máy)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN=/opt/homebrew/bin/brew      # Apple Silicon
  else
    BREW_BIN=/usr/local/bin/brew         # Intel
  fi
  eval "$("$BREW_BIN" shellenv)"

  # Thêm brew vào PATH cho các lần mở Terminal sau
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    echo "eval \"\$($BREW_BIN shellenv)\"" >> "$HOME/.zprofile"
    info "Đã thêm brew vào ~/.zprofile"
  fi
else
  info "Homebrew đã có: $(brew --version | head -n1)"
fi

brew update

# ---------- 2. Bản phân phối TeX ----------
case "$MODE" in
  full)
    if command -v pdflatex >/dev/null 2>&1; then
      info "pdflatex đã có, bỏ qua cài MacTeX."
    else
      info "Cài MacTeX đầy đủ (dung lượng lớn, sẽ mất một lúc)..."
      brew install --cask mactex
    fi
    ;;
  basic)
    if command -v pdflatex >/dev/null 2>&1; then
      info "pdflatex đã có, bỏ qua cài BasicTeX."
    else
      info "Cài BasicTeX..."
      brew install --cask basictex
    fi
    # Nạp PATH của TeX cho phiên hiện tại
    eval "$(/usr/libexec/path_helper)"
    if command -v tlmgr >/dev/null 2>&1; then
      info "Cập nhật tlmgr và cài các gói hay dùng cho paper..."
      sudo tlmgr update --self
      sudo tlmgr install latexmk biber collection-latexextra \
        collection-fontsrecommended collection-science collection-bibtexextra \
        collection-langother || warn "Một số gói cài lỗi, bạn có thể cài thêm sau bằng: sudo tlmgr install <tên-gói>"
    else
      warn "Chưa thấy tlmgr. Hãy mở lại Terminal rồi chạy lại script."
    fi
    ;;
  tectonic)
    if command -v tectonic >/dev/null 2>&1; then
      info "Tectonic đã có."
    else
      info "Cài Tectonic..."
      brew install tectonic
    fi
    ;;
esac

# ---------- 3. VS Code + LaTeX Workshop ----------
if ! command -v code >/dev/null 2>&1; then
  if [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  fi
fi

if command -v code >/dev/null 2>&1; then
  info "Cài extension LaTeX Workshop cho VS Code..."
  code --install-extension James-Yu.latex-workshop --force
else
  warn "Chưa thấy lệnh 'code'. Cài VS Code (brew install --cask visual-studio-code) hoặc"
  warn "mở VS Code > Cmd+Shift+P > 'Shell Command: Install code command in PATH', rồi chạy lại script."
fi

# ---------- 4. Kiểm tra ----------
echo
info "Kiểm tra phiên bản:"
for cmd in pdflatex xelatex latexmk biber tectonic; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "  %-10s OK  -> %s\n" "$cmd" "$(command -v "$cmd")"
  else
    printf "  %-10s (không có)\n" "$cmd"
  fi
done

echo
info "Xong. Mở lại Terminal và VS Code để nhận PATH mới."
info "Biên dịch thử:  latexmk -pdf main.tex   (hoặc: tectonic main.tex)"