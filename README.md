# HaUI LaTeX Beamer template

Slide báo cáo nghiên cứu khoa học theo màu HaUI / SICT. **Compiler: XeLaTeX** (Overleaf: Menu > Compiler).

## Cấu trúc
- `beamerthemeHaUI.sty` — theme (đặt cạnh `main.tex`)
- `main.tex` — slide mẫu (có logo OptiVisionLab)
- `main-nolab.tex` — bản tương tự nhưng không có logo OptiVisionLab (`\renewcommand{\hauilogolab}{}`)
- `fonts/` — Montserrat, Source Sans 3 (OFL), nạp bằng đường dẫn tương đối
- `logo/` — `logo-sict-ngang.png`, `optivisionlab-crop.png` (logo lab đã cắt sát, dùng mặc định), `optivisionlab.png` (bản gốc)
- `images/` — ảnh nền (`bg-title.jpg`, `bg-thanks.jpg` đã cắt 16:9)

## Layout hiện có
| Layout | Cách dùng |
|---|---|
| Title | `\begin{frame}[plain]\titlepage\end{frame}` |
| Outline | `\begin{frame}{...}\hauisidephoto \tableofcontents[hideallsubsections]\end{frame}` |
| Section divider | tự sinh khi gọi `\section{...}` |
| Content | frame thường: `itemize`, `enumerate`, `columns`, `block`, `exampleblock`, `alertblock` |
| Experiments & Results | `columns` + `table` (booktabs) và biểu đồ `pgfplots` (`ybar`) với màu theme |
| Conclusion & Future Work | `block` (Conclusion) + `exampleblock` (Future Work) + `alertblock` (Limitations) |
| References | `\begin{frame}[allowframebreaks]{References}` + `thebibliography`, trích dẫn bằng `\cite{key}` (nhãn số trong vòng tròn navy, tác giả in đậm) |
| Thank you | `\hauithanksframe` (đặt `\contactinfo{...}`) |

## Metadata
`\title`, `\subtitle`, `\author`, `\institute`, `\date`, `\confname{...}` (dòng hội nghị màu vàng trên tiêu đề), `\contactinfo{...}` (slide Thank you).

Mẹo: dùng `\title[tên ngắn]{...}` và `\author[viết tắt]{...}` vì footer hiển thị bản ngắn. Tiêu đề trang bìa cỡ lớn, không cần chèn `\\` thủ công.

## Tuỳ biến
Các lệnh sau đặt trong `beamerthemeHaUI.sty`, có thể `\renewcommand` trong `main.tex` sau `\usetheme{HaUI}`:
- `\hauilogosict`, `\hauilogolab` — đường dẫn logo. Đặt `\renewcommand{\hauilogolab}{}` để bỏ logo lab (trang bìa và slide Thank you tự ẩn).
- `\hauibgtitle`, `\hauibgthanks` — ảnh nền trang bìa / Thank you.
- `\hauithankstitle`, `\hauithankssub` — chữ trên slide Thank you.

## Gói cần thiết
`main.tex` nạp thêm `booktabs` và `pgfplots` (`\pgfplotsset{compat=1.17}`) cho bảng và biểu đồ; cần có trong bản TeX (TeX Live đầy đủ hoặc Overleaf là đủ). Cài nhanh: `install_latex.sh`.

## Biên dịch local
```
latexmk -xelatex main.tex
latexmk -xelatex main-nolab.tex
```
Chạy hai lần (latexmk tự làm) để cập nhật mục lục và tài liệu tham khảo.
