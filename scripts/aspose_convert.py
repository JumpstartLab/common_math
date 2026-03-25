"""
Convert Eureka Math DOCX → HTML using Aspose.Words.
Compare output quality to mammoth-based pipeline.
"""

import aspose.words as aw
import os
import re

DOCX_PATH = "Module 2/Math G5-M2 Lessons/Math-G5-M2-Topic-B-Lessons-3-9/math-g5-m2-topic-b-lesson-4.docx"
OUTPUT_HTML = "lesson-4-aspose.html"
OUTPUT_PDF = "lesson-4-aspose.pdf"
LICENSE_PATH = "Aspose.Words.lic"

# Apply license (removes watermark and size limits)
if os.path.exists(LICENSE_PATH):
    license = aw.License()
    license.set_license(LICENSE_PATH)
    print(f"License applied from {LICENSE_PATH}")
else:
    print("WARNING: No license file found — output will have evaluation watermark")

# Load the document
doc = aw.Document(DOCX_PATH)

# === HTML Export ===
html_options = aw.saving.HtmlSaveOptions()
html_options.export_images_as_base64 = True  # Embed images inline
html_options.css_style_sheet_type = aw.saving.CssStyleSheetType.EMBEDDED
html_options.pretty_format = True
html_options.export_page_setup = True  # Include page margins etc.

doc.save(OUTPUT_HTML, html_options)
print(f"Wrote {OUTPUT_HTML} ({os.path.getsize(OUTPUT_HTML):,} bytes)")

# === PDF Export (using Aspose's own renderer) ===
pdf_options = aw.saving.PdfSaveOptions()
pdf_options.compliance = aw.saving.PdfCompliance.PDF17
doc.save(OUTPUT_PDF, pdf_options)
print(f"Wrote {OUTPUT_PDF} ({os.path.getsize(OUTPUT_PDF):,} bytes)")

# === Quick analysis of the HTML ===
with open(OUTPUT_HTML, 'r', encoding='utf-8') as f:
    html = f.read()

print(f"\nHTML analysis:")
print(f"  Total size: {len(html):,} chars")
print(f"  Images: {html.count('data:image')}")
print(f"  Tables: {html.count('<table')}")
print(f"  Custom styles preserved: {bool(re.search(r'ny-h[234]|ny-paragraph|ny-list', html))}")
print(f"  CSS classes: {len(re.findall(r'class=\"[^\"]+\"', html))}")
print(f"  Position absolute: {html.count('position:absolute') + html.count('position: absolute')}")

# Check for VML/SVG content
print(f"  SVG elements: {html.count('<svg')}")
print(f"  Contains -aw- properties: {bool(re.search(r'-aw-', html))}")

# Check for watermark
if 'Evaluation' in html or 'Aspose' in html:
    print(f"  ⚠ Contains evaluation watermark")
