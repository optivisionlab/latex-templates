# HaUI LaTeX Beamer template

Slide báo cáo nghiên cứu khoa học theo màu HaUI / SICT. **Compiler: XeLaTeX** (Overleaf: Menu > Compiler).

## Cấu trúc
- `beamerthemeHaUI.sty` — theme (đặt cạnh `main.tex`)
- `main.tex` — slide mẫu
- `fonts/` — Montserrat, Source Sans 3 (OFL), nạp bằng đường dẫn tương đối
- `logo/`, `images/` — logo và ảnh nền (`bg-title.jpg`, `bg-thanks.jpg` đã cắt 16:9)

## Layout hiện có
| Layout | Cách dùng |
|---|---|
| Title | `\begin{frame}[plain]\titlepage\end{frame}` |
| Outline | `\begin{frame}{...}\hauisidephoto \tableofcontents[hideallsubsections]\end{frame}` |
| Section divider | tự sinh khi gọi `\section{...}` |
| Content | frame thường: `itemize`, `enumerate`, `columns`, `block`, `exampleblock`, `alertblock` |
| Thank you | `\hauithanksframe` (đặt `\contactinfo{...}`) |

Mẹo: dùng `\title[tên ngắn]{...}` và `\author[viết tắt]{...}` vì footer hiển thị bản ngắn.

## Biên dịch local
`latexmk -xelatex main.tex`
