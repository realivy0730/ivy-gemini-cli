---
name: document-tools
description: "建立、編輯、分析 Office 文件（docx/xlsx/pptx/pdf），支援中文。Use when creating Word documents, Excel spreadsheets, PowerPoint presentations, or processing PDF files."
---

# Document Tools — Office 文件處理

## 架構描述
透過 Python 函式庫處理四種 Office 文件格式，支援中文 Unicode。
逆向工程自 Anthropic Claude Document Skills（/mnt/skills/public/）。

## 觸發方式
- 「建立 Word」「產生報告」「匯出 Excel」「做簡報」「填 PDF」
- 處理 .docx / .xlsx / .pptx / .pdf 檔案時

## 格式決策樹

```
使用者需求
├── 建立/編輯 Word (.docx)
│   ├── 新建 → python-docx（Python）
│   ├── 讀取文字 → pandoc 轉 markdown
│   └── 追蹤修訂 → ooxml 解包 + 編輯 XML
├── Excel (.xlsx)
│   ├── 新建/編輯 → openpyxl
│   ├── 資料分析 → pandas + openpyxl
│   └── 匯出 → pandas.to_excel()
├── PowerPoint (.pptx)
│   └── 新建/編輯 → python-pptx
└── PDF (.pdf)
    ├── 讀取文字 → pypdf
    ├── 填寫表單 → pypdf（fillable fields）
    └── 生成 PDF → pandoc 或 soffice --convert-to pdf
```

## 快速範例

### Word — 建立含中文的文件
```python
from docx import Document
doc = Document()
doc.add_heading('月報', level=1)
doc.add_paragraph('本月工作摘要...')
doc.save('report.docx')
```

### Excel — JSON 匯出為 Excel
```python
import pandas as pd
df = pd.DataFrame(data)
df.to_excel('output.xlsx', index=False, engine='openpyxl')
```

### PowerPoint — 建立簡報
```python
from pptx import Presentation
from pptx.util import Inches
prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[0])
slide.shapes.title.text = '專案報告'
slide.placeholders[1].text = '2026 Q2 進度'
prs.save('presentation.pptx')
```

### PDF — 讀取文字
```python
from pypdf import PdfReader
reader = PdfReader('input.pdf')
for page in reader.pages:
    print(page.extract_text())
```

## 中文注意事項
- docx/xlsx/pptx：原生支援 Unicode，中文直接寫入
- pptx 字型：指定中文字型避免方塊 `run.font.name = '微軟正黑體'`
- pdf 生成：用 `soffice --headless --convert-to pdf input.docx` 最穩定
- pandoc 轉換：`pandoc input.docx -o output.md` 支援中文

## 依賴
- python-docx, pypdf, openpyxl, python-pptx, pandas, defusedxml
- pandoc（brew install pandoc）

## 詳細參考
- references/anthropic-originals/ — Anthropic 官方原始 SKILL.md 和腳本
- docx 進階：references/anthropic-originals/docx/ooxml.md（OOXML 編輯）
- docx-js：references/anthropic-originals/docx/docx-js.md（JS 建立文件）

## 驗收標準
- [ ] 檔案成功產生且可用 Office/Preview 開啟
- [ ] 中文內容正確顯示（無亂碼、無方塊）
- [ ] 檔案大小合理（無異常膨脹）
