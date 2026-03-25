# Spike: DOCX → HTML → PDF Round-Trip

## Goal

Can we take an EngageNY DOCX file, extract the content, render it in the browser with CSS, and generate a PDF that closely matches the original? This proves we can own the rendering pipeline — foundational for the EngageNY modernization project.

## Test Document

Grade 5, Module 2, Lesson 4: "Convert numerical expressions into unit form as a mental strategy for multi-digit multiplication."

- Original DOCX: 2.6 MB, 203 paragraphs, 12 images, 5 tables, 6 sections
- Original PDF: 539 KB, ~10 pages

## Approach

1. **mammoth** converts DOCX → HTML using a style map that translates `ny-*` Word styles to semantic HTML classes
2. **CSS** styles those classes to match the original visual design
3. **Playwright** (headless Chromium) generates a PDF from the HTML
4. Compare generated PDF against original PDF visually

## What We Learned

### DOCX Structure (very parseable)

The EngageNY DOCXs use consistent custom paragraph styles that map directly to semantic content:

| Word Style | Meaning | HTML Mapping |
|------------|---------|--------------|
| `ny-h2` | Lesson title | `h1.ny-h2` |
| `ny-h2-sub` | Objective | `p.ny-h2-sub` |
| `ny-h3-boxed` | Major section header (Fluency Practice, Concept Development, etc.) | `h2.ny-h3-boxed` |
| `ny-h4` | Sub-section header | `h3.ny-h4` |
| `ny-h5` | Problem group header | `h4.ny-h5` |
| `ny-list-idented` | T:/S: teacher-student dialogue | `p.ny-list-indented` |
| `ny-materials` | Materials listing | `p.ny-materials` |
| `ny-paragraph` | Body text | `p.ny-paragraph` |
| `ny-bullet-list` | Bullet items | `li.ny-bullet-list` |
| `ny-callout-hdr` | Sidebar box header ("NOTES ON MULTIPLE MEANS OF...") | `.callout-header` |
| `ny-callout-text` | Sidebar box body text | `.callout-sidebar` |

This style system is consistent across lessons, which means one style map works for the whole curriculum.

### Images in the DOCX

12 images total in this lesson:
- **2 large PNGs (483KB each):** Duplicate of the same hand-drawn solution (landscape, 2864x1848)
- **1 massive PNG (362KB, 4712x6214):** Portrait-oriented tape diagram — this is the problematic one
- **2 medium PNGs (150-188KB):** Portrait tape diagrams
- **5 JPEGs (27-35KB):** Smaller hand-drawn diagrams (tape diagrams)
- **1 tiny PNG (1.6KB):** Callout box icon
- **1 pie chart:** NOT an image — it's a Word VML shape (vector markup), so mammoth can't extract it

### What Works Well (~90% of content)

- **All text content** converts faithfully — every dialogue line, problem, section
- **Semantic structure** preserved through style mappings
- **Section headers** styled with colored backgrounds and border accents
- **Callout sidebar boxes** float right with text wrapping
- **Most images** display at reasonable sizes with dimension-aware CSS classes
- **Print stylesheet** produces real PDFs via Playwright
- **The conversion pipeline is fast** — ~2 seconds for convert + PDF generation

### What Needs Work (~10% remaining)

1. **Portrait-oriented images** — Word stores these with rotation/positioning metadata (anchor elements with `wp:extent`, `wp:positionH`, `wp:positionV`) that mammoth doesn't extract. The 4712x6214 tape diagram appears rotated and side-by-side with another in the original PDF but renders portrait and oversized in our output.

2. **Image spatial layout** — In the original, images float next to text (e.g., Application Problem has the solution diagram floated right). Mammoth converts images inline without position information.

3. **VML shapes** — The pie chart in "Suggested Lesson Structure" and the colored legend squares are Word VML (Vector Markup Language), not images. Mammoth ignores VML entirely.

4. **Duplicate images** — Word sometimes stores the same image twice (inline + anchored). We added dedup but it's regex-based and fragile.

## Next Steps to Close the Gap

### Option A: Deeper DOCX XML Parsing (recommended)

Replace mammoth with direct `python-docx` + lxml parsing of the DOCX XML. This gives access to:
- `wp:anchor` and `wp:inline` elements with exact positioning data
- `wp:extent` for intended display size (not just pixel dimensions)
- `wp:positionH` / `wp:positionV` for float positioning
- `mc:AlternateContent` blocks that contain both VML and image fallbacks

This is more work upfront but gives full control over layout.

### Option B: LibreOffice Headless

Use `libreoffice --headless --convert-to html` or `--convert-to pdf` as the conversion engine. LibreOffice understands Word layout natively but produces messy HTML that's harder to style/customize.

### Option C: Hybrid Approach

Use mammoth for text extraction (it's great at that) but parse the DOCX XML directly for image positioning. This gets the best of both: clean semantic HTML for text + accurate image layout.

### Other Improvements

- **Generate the pie chart** from structured data (we know the time allocations from the text)
- **Add repeating page headers/footers** using CSS `@page` rules or Playwright header/footer options
- **Handle the colored legend squares** by replacing the VML with CSS-generated colored squares (we partially did this with `::before` pseudo-elements)

## Current State (after 19 iterations)

Visual fidelity estimate: **~95% on text/structure, ~85% on image layout**

### What's working:
- All text content converts faithfully — every T:/S: dialogue, problem, section
- Section headers with colored background and red left border
- Colored legend squares in Suggested Lesson Structure (replaced Wingdings with CSS)
- Callout sidebar boxes ("NOTES ON MULTIPLE MEANS") float right with text wrapping
- Application Problem image floats right with text wrapping — no duplicate
- Landscape tape diagrams (31/30 eights, 30/29 eights) centered at correct size with labels visible
- Content-hash matching connects mammoth's output to DOCX XML positioning data
- Portrait images constrained with dedicated CSS class to avoid blank pages
- Duplicate image detection and removal (content-hash based)
- Block-center images extracted from containing paragraphs for better page break behavior
- Worksheet thumbnails (Problem Set, Homework, Exit Ticket) display correctly
- Full pipeline runs in ~2 seconds

### Remaining issues:
1. **Portrait tape diagrams (3 images)** — constrained to 2.5in max-height which helps page flow, but the largest one (4712x6214) still pushes to its own page. In the original, Word uses absolute positioning. Rotation was attempted but these hand-drawn diagrams are intentionally portrait. The right long-term fix is CSS grid or side-by-side display.
2. **Pie chart missing** — the lesson structure pie chart is a Word VML shape, not an image. Would need VML→SVG conversion or regeneration from the structured time data (which is already in the text).
3. **One blank-ish page** — page 4 has just the large portrait image. Could be eliminated with more aggressive max-height or side-by-side layout.

## Architecture

The hybrid approach works well:

```
DOCX XML ──→ extract_images.py ──→ image_positions.json
                                          │
DOCX ──→ mammoth (style map) ──→ HTML ──→ post-process ──→ styled HTML
                                          │
                                    Playwright ──→ PDF
```

**Key insight:** mammoth is excellent for text/style conversion but loses all image positioning. The DOCX XML has exact positioning data (`wp:anchor`, `wp:extent`, `wp:positionH`). Connecting them via content-hash matching gives us the best of both.

## Mammoth Contribution Opportunity

mammoth.js (https://github.com/mwilliamson/mammoth.js) is the canonical version (MIT licensed). The Python version is a port. Key feature gaps that would be valuable upstream:

1. **Image positioning from wp:anchor** — mammoth currently emits all images inline. It has access to the anchor/inline distinction but doesn't expose it. Adding `position`, `width`, `height`, and `wrap` attributes to the image conversion callback would let consumers handle layout.
2. **VML shape support** — even basic conversion of VML rectangles/circles to HTML/SVG would help.
3. **Run style support for custom character styles** — styles like `ny-chart-sq-red` on runs (character-level formatting) aren't currently handled by the style map.

A PR adding option 1 would be the highest-impact contribution and directly serves our use case.

## Files

- `convert.py` — Hybrid DOCX → HTML converter (mammoth + XML positioning)
- `extract_images.py` — Parses DOCX XML for image positioning metadata
- `generate-pdf.js` — Playwright-based HTML → PDF generator
- `examine_docx.py` — Utility to inspect DOCX structure (styles, images, tables)
- `image_positions.json` — Extracted positioning data (generated)
- `lesson-4.html` — Current generated HTML output
- `lesson-4-generated.pdf` — Current generated PDF output
- `Module 2/.../*.docx` — Source DOCX
- `Module 2/.../*.pdf` — Original PDF (comparison target)
- `SPIKE.md` — This file

## Dependencies

- Python: `python-docx`, `mammoth`, `Pillow`, `lxml` (in `.venv/`)
- Node: `playwright` (in `node_modules/`)
- System: `pandoc` (installed via brew, not currently used but available)

## Running

```bash
# From the spikes/docx-roundtrip directory:
.venv/bin/python convert.py && node generate-pdf.js
# Output: lesson-4.html + lesson-4-generated.pdf
```

## Resolution: Aspose.Words

After 19 iterations with the mammoth-based pipeline (~92% fidelity), we evaluated Aspose.Words for Python via .NET ($1,199/year). It achieves ~99% fidelity out of the box:

- Side-by-side portrait images (the problem we spent an hour on) — just works
- VML shapes (pie chart) — rendered correctly
- Image positioning with absolute coordinates — preserved in HTML output
- Headers/footers with logos, page numbers, CC license badges — all present
- Page breaks matching the original Word layout
- Custom styles preserved as CSS classes

**Decision: Use Aspose.Words for the production pipeline.** The mammoth spike was valuable for understanding the DOCX structure and the hard problems, but Aspose solves them all for $1,199/year — a fraction of the engineering time cost.

**Files added:**
- `aspose_convert.py` — Aspose-based DOCX → HTML + PDF converter
- `Aspose.Words.lic` — 30-day temporary license
- `.venv-aspose/` — Python 3.13 venv (Aspose requires <3.14)
- `lesson-4-aspose.html` — Aspose HTML output (774KB, 65 images, 96 position:absolute)
- `lesson-4-aspose.pdf` — Aspose PDF output (789KB, ~99% fidelity to original)
- `research-tooling-review.md` — Full tooling comparison

**Open source contribution still planned:** mammoth.js image positioning PR would benefit the community, even though we're using Aspose for production.

## Next Steps

1. **Build the full conversion pipeline** with Aspose — batch process all Grade 5 Module 2 lessons
2. **Post-process Aspose HTML** for web-native use — strip absolute positioning, convert to responsive CSS
3. **Extract structured data** from Aspose output — lesson objectives, standards, vocabulary, problem sets
4. **Test across multiple grades/modules** to validate generalization
5. **Evaluate Aspose HTML vs Aspose PDF** — which output serves the web interface better?
6. **PR image positioning to mammoth.js** — still a worthwhile community contribution
