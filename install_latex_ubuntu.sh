#!/usr/bin/env bash
# Cài môi trường LaTeX trên Ubuntu/Debian: TeX Live (apt) + VS Code extension
# Cách dùng:
#   chmod +x install_latex_ubuntu.sh
#   ./install_latex_ubuntu.sh            # mặc định: basic (đủ cho template, XeLaTeX)
#   ./install_latex_ubuntu.sh full       # texlive-full đầy đủ (~5-6 GB)
#   ./install_latex_ubuntu.sh basic      # các gói hay dùng cho paper/beamer

set -euo pipefail

MODE="${1:-basic}"

info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

if [[ "$(uname -s)" != "Linux" ]] || ! command -v apt-get >/dev/null 2>&1; then
  error "Script này chỉ dành cho Ubuntu/Debian (cần apt-get)."
  exit 1
fi

case "$MODE" in
  full|basic) ;;
  *) error "Chế độ không hợp lệ: $MODE (dùng: full | basic)"; exit 1 ;;
esac

# Dùng sudo nếu không phải root
if [[ "$(id -u)" -eq 0 ]]; then
  SUDO=""
else
  if ! command -v sudo >/dev/null 2>&1; then
    error "Cần quyền root hoặc sudo."
    exit 1
  fi
  SUDO="sudo"
fi

export DEBIAN_FRONTEND=noninteractive

# ---------- 1. Cập nhật apt ----------
info "Cập nhật danh sách gói..."
$SUDO apt-get update

# ---------- 2. Bản phân phối TeX ----------
case "$MODE" in
  full)
    info "Cài texlive-full (dung lượng lớn, sẽ mất một lúc)..."
    $SUDO apt-get install -y texlive-full latexmk biber
    ;;
  basic)
    info "Cài TeX Live và các gói hay dùng cho paper/beamer..."
    $SUDO apt-get install -y \
      texlive-base texlive-latex-base texlive-latex-recommended texlive-latex-extra \
      texlive-xetex texlive-fonts-recommended texlive-fonts-extra \
      texlive-science texlive-pictures texlive-publishers \
      texlive-bibtex-extra texlive-lang-other texlive-plain-generic \
      latexmk biber fontconfig
    ;;
esac

# ---------- 3. VS Code + LaTeX Workshop ----------
if command -v code >/dev/null 2>&1; then
  info "Cài extension LaTeX Workshop cho VS Code..."
  code --install-extension James-Yu.latex-workshop --force
else
  warn "Chưa thấy lệnh 'code'. Cài VS Code (https://code.visualstudio.com/docs/setup/linux)"
  warn "rồi chạy: code --install-extension James-Yu.latex-workshop"
fi

# ---------- 4. Kiểm tra ----------
echo
info "Kiểm tra phiên bản:"
for cmd in pdflatex xelatex latexmk biber; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "  %-10s OK  -> %s\n" "$cmd" "$(command -v "$cmd")"
  else
    printf "  %-10s (không có)\n" "$cmd"
  fi
done

echo
info "Xong. Mở lại Terminal và VS Code để nhận PATH mới."
info "Biên dịch thử:  latexmk -xelatex main.tex   (template dùng XeLaTeX)"
