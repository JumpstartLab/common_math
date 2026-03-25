# DOCX → HTML → PDF Tooling Review

**Context:** EngageNY math curriculum DOCX files with custom paragraph styles (`ny-h2`, `ny-h3-boxed`, etc.), anchored images with absolute positioning, portrait hand-drawn diagrams, VML shapes (pie charts, colored squares), tables, headers/footers, and worksheet thumbnails. We've already reached ~85% fidelity with mammoth + custom DOCX XML parsing. This document surveys the remaining options to close the gap toward 99%.

---

## Baseline: What mammoth gives us

mammoth converts DOCX → clean semantic HTML using a configurable style map. It handles body text, custom paragraph styles (with explicit mapping), inline images, and tables. It does not read `wp:anchor` image positioning data, does not handle VML shapes, and does not expose character-level custom styles. Current fidelity: ~95% text/structure, ~85% image layout.

The hybrid approach already in use (mammoth for text + direct DOCX XML parsing for image positioning metadata) represents the high-water mark of what mammoth-based pipelines can achieve.

---

## 1. LibreOffice Headless

### Overview

LibreOffice is a full office suite that can read DOCX natively via its OOXML import filter. It supports three relevant conversion paths:

- `libreoffice --headless --convert-to pdf file.docx` — direct DOCX → PDF
- `libreoffice --headless --convert-to html file.docx` — DOCX → HTML (messy)
- XHTML export filter via the Writer2xhtml extension

### DOCX → PDF (`--convert-to pdf`)

This is LibreOffice's strongest conversion path for our use case. LibreOffice interprets the DOCX layout model (page size, margins, floated images, anchored objects) and renders to PDF through its own layout engine. VML shapes are partially supported — LibreOffice has active VML import code (`oox::vml` module) and ongoing fixes landed in 2024 (z-index import, textbox handling). For simple VML shapes like colored rectangles, rendering is generally correct; complex chart VML is more problematic.

**Known fidelity gaps vs. Word-generated PDF:**
- **Fonts:** The single biggest source of reflow. If the exact fonts used in the DOCX are not installed on the conversion server, LibreOffice substitutes fallback fonts (typically DejaVu), which changes character metrics, rewraps lines, and shifts page breaks. In production Docker deployments this requires explicitly installing all fonts (e.g., calibri, cambria, arial) from Microsoft's font packages or using `ttf-mscorefonts-installer`. Without this, layout differences are guaranteed.
- **Anchored image positioning:** LibreOffice generally respects `wp:anchor` positioning with text wrap, but fine-grained absolute positioning (`wp:positionH` / `wp:positionV` with `relativeFrom="page"`) can drift slightly from Word's rendering, particularly for overlapping objects.
- **VML pie charts / SmartArt:** VML charts created by Word's chart engine (not DrawingML) have partial support. Simple geometric VML (rectangles, circles with fills) renders correctly; word chart objects may appear as blank rectangles or be omitted.
- **DOCX form fields / content controls:** Grey blocks can appear where Word form fields were (known LibreOffice bug).
- **Page-level layout reflow:** Complex documents sometimes render an extra page or lose a page compared to Word's output due to differences in line-spacing calculations.

**Practical fidelity estimate for EngageNY docs:** ~80–90% against a Word-generated PDF. Better than mammoth on image positioning; worse on VML shapes if fonts are correctly installed. The large portrait tape diagram images and their absolute placement are handled correctly as LibreOffice understands the DOCX layout model end-to-end.

### DOCX → HTML (`--convert-to html`)

The built-in HTML export is widely regarded as poor for downstream use. It produces:
- All images embedded as base64 data URIs (no external image files by default)
- Inline `style=""` attributes on nearly every element rather than CSS classes
- Table cells with pixel-exact widths baked in
- Absolute-positioned floats rendered using CSS `position:absolute` relative to the page — which only approximates the layout rather than being web-native
- No semantic class names corresponding to Word styles

This output is not suitable as a starting point for a styled web-native HTML pipeline. It would require extensive post-processing that would be harder than mammoth's already-clean output.

### XHTML Export (Writer2xhtml Extension)

The `Writer2xhtml` extension (available as a LibreOffice extension, packaged as `libreoffice-writer2xhtml` in Debian/Ubuntu) provides a higher-quality XHTML/CSS2 export with:
- Ability to map Writer paragraph styles to CSS classes
- EPUB 2/3 output support
- MathML support

However, it operates on the LibreOffice internal document model (after DOCX import), not directly on the DOCX XML. This means VML shapes and any elements that LibreOffice's DOCX importer loses are already gone by the time Writer2xhtml runs. It is also primarily designed for ODT workflow, not as a DOCX → web-HTML tool, and requires Java. Its advantage over the built-in filter is CSS class-based output, but the round-trip loss from DOCX → LibreOffice Writer → XHTML is additive.

### UNO API / unoserver Scripting

LibreOffice exposes its full functionality through the UNO API. The recommended production wrapper is **unoserver** (the active replacement for the archived unoconv project, last updated 2025). It runs LibreOffice as a persistent listener process, accepting conversion requests over a port with 2–4x better throughput than per-invocation `--headless` calls.

Using UNO directly (python-uno) you can control export filter options programmatically — for example, specifying PDF/A compliance levels, setting specific font embedding options, or customizing the HTML export filter parameters. This is more powerful than the CLI but requires running the full LibreOffice UNO bridge.

**unoconv** was archived in March 2025; unoserver is the maintained successor.

### Automation-friendliness

Excellent. LibreOffice headless runs in Docker (official image available), integrates with Gotenberg for API-based access, and runs on Linux CI pipelines without a display server. macOS is supported but less commonly used in server deployments.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity (PDF path) | ~80–90% with fonts installed; ~70% without |
| Image positioning | Good — reads wp:anchor natively |
| VML shapes | Partial — simple geometry yes, chart VML unreliable |
| Custom styles → HTML | Poor (inline styles, no class names) |
| Automation | Excellent — headless, Docker, unoserver |
| License | LGPL (free) |
| Platform | Cross-platform (Linux recommended for CI) |
| Maintenance | Active — The Document Foundation, regular releases |

**Recommendation for this project:** Use `--convert-to pdf` as a comparison baseline and for the specific pages that mammoth handles poorly (image-heavy pages). Do not use `--convert-to html` as a web pipeline; it is not web-native.

---

## 2. Pandoc

### Overview

Pandoc is a universal document converter. For `pandoc -f docx -t html`, it reads the DOCX file and converts through its internal abstract syntax tree (AST).

### Custom Style Handling

Pandoc handles custom Word paragraph styles differently from mammoth: custom styles appear as `data-custom-style="ny-h2"` attributes on span/div elements rather than as class names. To convert these to CSS classes, a Lua filter or post-processing step is required. This is workable but adds a step compared to mammoth's explicit style map.

Character-level custom styles (run-level formatting like `ny-chart-sq-red`) similarly appear as `data-custom-style` on spans.

### Image Positioning

Pandoc does not extract `wp:anchor` positioning data. Issue #8207 in the pandoc repository specifically requests `wp:wrapSquare` / text-wrap-around support for images, and as of 2024 it remains unimplemented. Images are emitted inline without position or wrap information, same as mammoth.

SVG images in DOCX are converted to PNG during the pandoc DOCX → HTML path.

### VML Shapes

Pandoc has no VML support. VML shapes are silently dropped from output.

### Standalone HTML with Embedded Images

`pandoc --standalone --embed-resources -f docx -t html` produces a single HTML file with base64-embedded images. Media is extracted to a folder by default. This is on par with mammoth.

### Comparison to mammoth

- Custom styles: pandoc uses `data-custom-style` attributes (needs filter to get to classes); mammoth uses an explicit style map that gives you direct CSS classes — mammoth wins here for our use case.
- Image positioning: both lose it.
- VML: both lose it.
- Text fidelity: roughly equivalent; pandoc's AST model may handle some edge cases (footnotes, comments, track changes) better than mammoth.
- Pandoc is a much larger dependency (Haskell runtime) than mammoth (pure Python/JS).

For EngageNY documents, pandoc offers no meaningful advantage over mammoth and requires extra work to get CSS classes from `data-custom-style` attributes.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity | Similar to mammoth (~85%) |
| Image positioning | Not preserved |
| VML shapes | Not supported |
| Custom styles | data-custom-style attributes (filter required for classes) |
| Automation | Excellent — single binary, CI-friendly |
| License | GPL (free) |
| Platform | Cross-platform |
| Maintenance | Very active |

**Recommendation:** Not better than mammoth for this use case. Skip unless you need pandoc for other format targets.

---

## 3. Microsoft Word Automation (macOS)

### AppleScript

Microsoft Word on macOS has a full AppleScript dictionary. You can automate:
- Opening a DOCX file
- Saving as PDF via `save as ... file format: format PDF`
- Saving as filtered HTML via `save as ... file format: format filtered HTML`
- Saving as web archive

This is scriptable from the command line using `osascript`. The practical invocation looks like:

```applescript
tell application "Microsoft Word"
  open POSIX file "/path/to/file.docx"
  save as active document file name "/path/out.pdf" file format format PDF
  close active document
end tell
```

### Quality of Word's Own PDF Export

Word for Mac produces the highest-fidelity PDF of any tool because it is using the same rendering engine that authored the document. VML shapes, custom styles, anchored images, page headers/footers — all are rendered correctly. This is effectively the gold standard for DOCX → PDF.

Word's "Save as Filtered HTML" produces reasonably clean HTML compared to LibreOffice's HTML export, but it still uses inline styles and bakes Word's layout decisions (absolute positioning, explicit pixel dimensions) into the output. It is not suitable as a starting point for a re-styled web-native HTML pipeline, but it is useful for visual comparison.

### Limitations for CI/Production

- Requires a licensed copy of Microsoft Word installed on macOS.
- Not viable on Linux CI (no Word for Linux).
- AppleScript permission dialogs can interrupt batch processing in macOS sandboxed environments.
- Word version compatibility: some AppleScript syntax changed between Word 2016 and Word 365; the save format enumeration changes between versions.
- **Not a viable pipeline for server/CI use** — macOS-only, GUI dependency, license requirement.

### Office JavaScript API

The Office JS API is designed for add-ins running inside Word's task pane, not for server-side batch conversion. It can export the current document as a compressed DOCX blob or as PDF via `getFileAsync`, but requires a running Word session with a user interface. It is not a headless automation tool.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| PDF fidelity | Near-perfect (it's Word rendering Word) |
| HTML output quality | Messy inline styles, not web-native |
| Automation | Limited — macOS only, AppleScript, GUI required |
| License | Requires MS Word license |
| Platform | macOS only |
| CI viability | Low |

**Recommendation:** Use Word on macOS to generate the ground-truth comparison PDFs for visual diff testing. Do not use it as a production conversion pipeline.

---

## 4. Google Docs API

### Upload DOCX → Export HTML or PDF

The workflow: upload DOCX to Google Drive → it converts to Google Docs format → export as HTML or PDF via the Drive export API (`?mimeType=text/html` or `application/pdf`).

### HTML Export Fidelity

Google Docs' HTML export produces HTML with inline styles and Google-specific markup. Custom Word paragraph styles are lost during the DOCX → Google Docs import — Google Docs has its own fixed set of paragraph styles. The `ny-h2`, `ny-h3-boxed` etc. styles would either be mapped to the nearest Google Docs equivalent or collapsed to "Normal text".

### PDF Export Fidelity

Google Docs is reasonably faithful to DOCX formatting for standard documents, but has known gaps:
- **Fonts:** Non-standard fonts not available on Google's servers are substituted.
- **Image positioning:** Anchored images with text wrap are generally preserved during import, but pixel-perfect placement matching Word's output is not guaranteed.
- **VML shapes:** Google Docs does not support VML; VML elements from DOCX are dropped on import.
- **Custom styles:** Lost on DOCX import.
- **Complex tables:** Fidelity varies.

Fidelity is generally considered lower than LibreOffice for complex DOCX documents with proprietary formatting.

### Automation

The Google Drive API is well-documented and widely used. Workflow:
1. `POST` to Drive upload endpoint with DOCX binary, `convertTo=true` to auto-convert
2. `GET` the export URL with desired MIME type

This is fully automatable via API, requires Google API credentials, and can run in CI. Rate limits apply (Drive API quotas).

### Practical Fidelity for EngageNY Docs

Custom `ny-*` styles → gone. VML shapes → gone. Image wrapping → partially preserved. For our specific use case, Google Docs introduces regressions compared to mammoth's style-map approach. The PDF export quality is roughly comparable to LibreOffice headless.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity (PDF) | ~75–85% |
| Custom styles | Lost on import |
| Image positioning | Partially preserved |
| VML shapes | Not supported |
| Automation | Good — REST API, OAuth, quotas apply |
| License | Free tier with quotas; Google account required |
| Platform | Cloud-only |
| Privacy | Documents pass through Google servers |

**Recommendation:** Not competitive for this use case. Custom style preservation is a hard requirement, and Google Docs discards them on import. VML also drops. Skip.

---

## 5. docx4j / Apache POI (Java)

### docx4j

docx4j (from Plutext, Apache license) is the most feature-complete Java library for DOCX manipulation. It has a DOCX → HTML export path and a DOCX → PDF path via XSL-FO → Apache FOP.

**HTML export:** docx4j's HTML output is described as suitable for "paragraphs, tables and images" in straightforward documents. It does not handle VML shapes, SmartArt, WordArt, or DrawingML charts. Image positioning from `wp:anchor` is partially supported — the library reads anchor data but translating it faithfully to CSS layout is incomplete.

**PDF via XSL-FO:** The PDF path converts DOCX → JAXB objects → XSL-FO → FOP-generated PDF. This is slower and has lower fidelity than LibreOffice headless for complex Word documents. Known issues include image placement drift and certain table formatting losses.

**Custom styles:** docx4j preserves paragraph style names in its object model and can emit them as CSS classes in HTML output, though the mapping is not as clean as mammoth's explicit style map.

**VML:** Explicitly documented as unsupported in docx4j's HTML export. "Can't handle more exotic features, such as equations, SmartArt, or WordArt (DrawingML or VML)."

### Apache POI

Apache POI (XWPF module) is a lower-level Java API for reading/writing DOCX. It does not have a built-in DOCX → HTML converter. It provides programmatic access to the document's XML elements, similar to what we're doing with python-docx + lxml. Building a converter from scratch on POI would be a significant engineering effort.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity | ~75–85% (comparable to LibreOffice headless) |
| Custom styles | Preserved in object model; CSS output possible |
| Image positioning | Partial |
| VML shapes | Not supported in HTML export |
| Automation | Good — JVM, headless, CI-friendly |
| License | Apache 2.0 (free) |
| Platform | JVM (cross-platform) |
| Maintenance | Active but slower pace than LibreOffice |

**Recommendation:** No advantage over LibreOffice headless for our use case, and requires a JVM dependency. Skip unless the team is already Java-based.

---

## 6. Aspose.Words

### Overview

Aspose.Words is a commercial document processing library available for .NET, Java, Python (via .NET), and Node.js (via .NET). It is widely cited as having the highest DOCX → HTML and DOCX → PDF fidelity among commercial tools.

### HTML Export Fidelity

Aspose.Words' HTML export has several features directly relevant to our use case:

**Anchored image positioning:** When `ExportRoundtripInformation = true`, Aspose.Words emits CSS properties with `-aw-*` prefixes to encode Word positioning metadata: `-aw-left-pos`, `-aw-top-pos`, `-aw-rel-hpos`, `-aw-rel-vpos`, `-aw-wrap-type`. This round-trip information can be read back to reconstruct the layout — or post-processed to emit proper `position: absolute` CSS for web rendering. This is a significant advantage over every open-source tool reviewed here.

**VML shapes:** Aspose.Words supports VML import and can export VML shapes to HTML as SVG, PNG, or EMF images (configurable via `MetafileFormat`). Simple geometry (colored rectangles, circles) renders correctly. Word VML charts may be rasterized rather than converted to chart data.

**Custom paragraph styles:** Aspose.Words preserves style names and emits them as CSS class names in HTML output. The `CssClassNamePrefix` option lets you namespace the classes to avoid collisions. This is directly usable without a style map layer.

**HtmlFixed vs. HtmlFlow modes:** `HtmlFixed` export produces absolute-positioned CSS approximating the page layout (similar to LibreOffice headless HTML). `HtmlFlow` (default) produces flowing HTML more suitable for web rendering. For our pipeline, `HtmlFlow` with `ExportRoundtripInformation` is the interesting mode.

### PDF Export Fidelity

Aspose.Words has its own layout engine (no dependency on LibreOffice or Word) and is frequently cited as producing PDF output very close to Word's own output — often better than LibreOffice headless. The layout engine handles font metrics, anchored image placement, and VML shapes. **This is likely the highest-fidelity open-to-closed-source tool for DOCX → PDF without requiring Word.**

### Pricing

- **Developer license (single developer):** starts at approximately $1,175/year for Aspose.Words for Python (via .NET).
- **Developer OEM license** (for SaaS/end-user products): starts higher; exact pricing requires contacting Aspose. Typical entry-level OEM is $10,000–$20,000+ annually.
- **Metered API:** Aspose also offers pay-per-page cloud API pricing.

A free trial watermarks output. The evaluation mode adds a watermark to every document.

### Platform

Aspose.Words for Python via .NET runs on macOS and Linux (requires .NET runtime 6.0+). The Node.js and Java variants similarly cross-platform. Docker-deployable.

### Maintenance and Maturity

Aspose has been developing document processing libraries since ~2002. Aspose.Words is one of their flagship products with monthly releases. Well-documented API reference.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity (HTML) | High — -aw-* CSS properties preserve anchor positioning |
| Visual fidelity (PDF) | Very high — own layout engine, often Word-comparable |
| Custom styles | Preserved as CSS class names |
| Image positioning | Best-in-class among reviewed tools |
| VML shapes | Supported — converts to SVG/PNG |
| Automation | Excellent — library API, no external process |
| License | Commercial — $1,175+/year per developer |
| Platform | Cross-platform (.NET runtime required) |
| Maintenance | Very active, monthly releases |

**Recommendation:** The strongest option for near-99% fidelity if budget permits. The `-aw-*` CSS round-trip information for anchored images and VML-to-SVG conversion address both of the hardest remaining problems in the mammoth pipeline. Evaluate with the free trial first; watermarked trial output is still useful for fidelity assessment.

---

## 7. Gotenberg / unoconv / unoserver

### Gotenberg

Gotenberg is a Docker-based HTTP API for document conversion. It wraps LibreOffice (via unoserver) for Office document conversion and Chromium for HTML → PDF. The DOCX → PDF path goes through LibreOffice — so Gotenberg's fidelity ceiling is the same as LibreOffice headless.

Gotenberg adds:
- Clean REST API (multipart form POST, PDF response)
- Chromium path for HTML → PDF (high fidelity for web-native HTML)
- PDF/A support, page ranges, metadata options
- Docker packaging with LibreOffice and fonts pre-installed (though you may still need to add MS fonts)

For our pipeline, Gotenberg is useful as the **HTML → PDF step** using its Chromium engine — this is equivalent to our current Playwright usage but with a more production-ready containerized form. It does not improve DOCX → HTML conversion quality.

**User reports:** Gotenberg is described as "99.9% faithful to the original docx" for typical business documents when fonts are properly installed. For EngageNY's complex layout, expect the same 80–90% fidelity as direct LibreOffice headless.

### unoserver

The recommended LibreOffice scripting bridge for production (successor to archived unoconv). Runs LibreOffice as a persistent listener, provides 2–4x better throughput than per-invocation headless. Python client: `pip install unoserver`. REST interface available.

unoserver is appropriate if you want to batch-convert DOCX → PDF via LibreOffice without Gotenberg's overhead.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| DOCX → PDF fidelity | Same as LibreOffice headless |
| HTML → PDF fidelity | High (Chromium) |
| Automation | Excellent — REST API, Docker |
| License | Free (Apache/MIT) |
| Platform | Linux/Docker recommended |

**Recommendation:** Use Gotenberg (or bare unoserver) as a production-ready packaging of LibreOffice conversion. For the HTML → PDF step in our pipeline, Gotenberg's Chromium engine is a production-hardened version of what we already do with Playwright.

---

## 8. Node.js DOCX Libraries (Beyond mammoth)

### docx-preview (docxjs) — VolodymyrBaydalka

`docx-preview` (npm package, ~200 dependents) is a browser-side DOCX rendering library. It renders the DOCX as HTML inside a container element, aiming to visually match Word's rendering.

**Key characteristics:**
- Renders to actual HTML/CSS elements (not canvas), which is important for print/PDF
- Handles text formatting, tables, images, lists, background colors, merged cells
- Supports `breakPages` option for page-by-page rendering
- Has `experimental` flag for features under development
- More visually accurate than mammoth for browser preview use cases

**Limitations for our use case:**
- Designed for browser-based preview, not server-side batch conversion (though `docx-preview-node` is an npm variant for Node.js server use)
- Anchored image positioning: the library reads DOCX XML including anchor elements, but faithful text-wrap CSS implementation is partially experimental
- VML shapes: partial support at best — it attempts canvas-based fallback for unsupported elements
- The project is maintained but with slower cadence (version 0.3.7 as of late 2025)

**Comparison to mammoth:** docx-preview produces better visual output than mammoth without a custom style map, but worse semantic HTML. For EngageNY where we have an explicit style map and need CSS class names, mammoth's approach is cleaner. If the goal shifts to "visual preview in a browser" rather than "semantically-structured web content," docx-preview is worth considering.

### html-docx-js / docx

These npm packages are primarily for generating DOCX from HTML, not for DOCX → HTML conversion. Not relevant.

### Summary

| Dimension | Assessment |
|-----------|-----------|
| Visual fidelity | Better than mammoth without style map; comparable with |
| Anchored images | Partial |
| VML | Partial/experimental |
| Custom styles → CSS classes | Requires post-processing |
| Automation | Node.js server-side possible (docx-preview-node) |
| License | MIT (free) |
| Maintenance | Active but slower pace |

**Recommendation:** Interesting for a browser-native preview widget, but not the right tool for our pipeline which needs clean semantic CSS-class-based HTML.

---

## 9. Hybrid Approaches

### 9a. mammoth + Direct DOCX XML Parsing (Current Approach)

This is what the spike already implements. The insight: mammoth handles text/structure excellently; the DOCX XML provides `wp:anchor` positioning data that mammoth ignores. Content-hash matching connects mammoth's image output to the extracted positioning metadata.

**Remaining gaps this approach cannot close without deeper work:**
- VML shapes (pie charts): the DOCX XML has `mc:AlternateContent` blocks with both VML and a `wp:extent`-sized image fallback. The fallback is usually a rasterized PNG that mammoth should be able to extract if the alternate content branch is parsed correctly.
- Portrait image side-by-side layout: needs either CSS grid/flexbox layout logic or reading the specific DOCX positioning that places two images adjacent.

**Recommended extensions:**
1. Parse `mc:AlternateContent` to extract VML image fallbacks (rasterized PNGs) that mammoth currently skips
2. Detect adjacent anchored images via their `wp:positionH`/`wp:positionV` values and emit side-by-side containers in HTML

### 9b. LibreOffice for PDF + mammoth for HTML

Use two parallel paths:
- mammoth → web-native HTML (for web rendering, accessibility, search)
- LibreOffice headless → PDF (for high-fidelity print output)

This acknowledges that no single DOCX → HTML → PDF pipeline will match Word's PDF fidelity for these complex documents. The PDF comes from LibreOffice (or Word if available); the HTML comes from mammoth. The tradeoff: the HTML and PDF may not be pixel-identical — but they represent the same content.

**Fidelity of this path:** LibreOffice PDF ~80–90% vs. Word PDF (with fonts installed). mammoth HTML is semantically rich and web-native.

### 9c. Word (macOS) for Reference PDFs + mammoth for Web

Use Word on macOS to generate the ground-truth PDFs (100% fidelity, since it's Word itself), and deploy the mammoth → HTML pipeline for the web product. Accept that the generated PDF from Playwright/Chrome won't match the Word PDF exactly, and treat that as a known gap.

**Practical implication:** The EngageNY curriculum documents already have canonical Word-generated PDFs distributed alongside the DOCXs. If the product goal is "web-native lesson view," the printed PDF comparison is a quality check, not the primary deliverable.

### 9d. Aspose.Words for HTML + Playwright for PDF

Use Aspose.Words' flowing HTML output (with `-aw-*` round-trip CSS and VML-to-SVG conversion) as the HTML layer, then generate PDF via Playwright/Chrome. This theoretically gives:
- Anchored image positions reconstructed from `-aw-*` CSS (with post-processing JavaScript to apply `position:absolute`)
- VML shapes converted to inline SVG
- Custom styles preserved as CSS class names

This is the highest-fidelity fully-automatable pipeline available short of using Word itself. Cost: $1,175+/year.

---

## 10. Browser-Based PDF Rendering (CSS Paged Media)

The current approach (Playwright/Chromium headless) already uses a browser for HTML → PDF. The remaining question is whether a CSS Paged Media renderer would produce better print output than Chrome.

### Prince XML

Prince XML (YesLogic) is widely recognized as producing the highest-quality HTML → PDF output available. It fully implements CSS Paged Media Level 3, including:
- `@page` rules with named pages, page-margin boxes
- CSS Floats for figures
- Footnotes, running headers/footers with content-from-element
- Column layout with proper page-break control
- Hyphenation

**Quality:** Best-in-class for HTML → PDF. For a well-structured HTML with good print CSS, Prince produces output that rivals InDesign-generated PDFs.

**Pricing:** Starts at ~$2,000–$2,500/year for a server license. Free non-commercial version watermarks output.

**Platform:** macOS, Linux, Windows. Docker-deployable.

**Relevant for this project:** If we can get high-quality HTML from Aspose.Words (or from the extended mammoth pipeline), Prince would convert it to PDF with better page-break handling, header/footer placement, and float control than Chrome. The combination of Aspose.Words (HTML generation) + Prince XML (PDF generation) is the theoretical ceiling for non-Word tooling.

### WeasyPrint

WeasyPrint (Kozea/CourtBouillon, LGPL) is the best open-source CSS Paged Media renderer. It supports `@page`, page margins, running headers/footers, and basic float handling.

**Limitations vs. Prince:**
- No JavaScript support (pure CSS rendering)
- Multi-column layout has incomplete `break-before`/`break-after` support
- Column spans not supported
- Float positioning in paged contexts is imperfect
- Slower than Chrome for complex documents

**Quality:** For simple to moderately complex HTML, WeasyPrint produces good PDFs. For our EngageNY documents with floated callout boxes and multi-column-ish layouts, it will handle most cases but may have edge issues.

**Pricing:** Free, LGPL.

**Platform:** Python package, Linux/macOS.

**Recommendation:** A reasonable free alternative to Prince for the HTML → PDF step if better page-break control than Chrome is needed. Test on representative documents; WeasyPrint's float handling is the likely failure mode.

### PagedJS

PagedJS is a JavaScript polyfill for CSS Paged Media that runs in a browser (Chromium). It intercepts CSS Paged Media properties that Chrome doesn't implement natively and re-renders the document accordingly.

**Status:** PagedJS was removed from the print-css.rocks comparison test suite in 2023 due to public inactivity, unfixed bugs, and maintenance concerns. As of 2025 the project appears to have resumed some activity, but it is not recommended for production use. Chrome's native print support has improved, reducing PagedJS's advantage.

**Recommendation:** Skip for production pipelines. The complexity of running PagedJS in a Playwright environment plus its known bugs outweighs any benefit over Chrome's native print support.

### Chrome/Playwright (Current Approach)

Chrome's headless print-to-PDF (`page.pdf()` in Playwright) supports:
- `@media print` rules
- `@page` rules (size, margins)
- `page-break-before/after/inside` (now `break-before/after/inside`)
- Header and footer templates (Playwright `headerTemplate`/`footerTemplate`)
- Background graphics

**Gaps:** Chrome does not implement CSS Paged Media's named pages, `@page :left/:right`, page-margin boxes (for running headers), or CSS Floats in paged context beyond what its normal flow model handles. For complex page layouts with true float-into-margin behavior, Chrome falls short of Prince.

For EngageNY documents, Chrome is adequate for the text/structure portion; the remaining fidelity gaps are primarily in the DOCX → HTML conversion step (image positioning, VML) rather than in the HTML → PDF rendering step.

---

## Comparative Matrix

| Tool | DOCX→HTML | DOCX→PDF | Image Anchor | VML | Custom Styles | Cost | CI-Friendly |
|------|-----------|----------|--------------|-----|---------------|------|-------------|
| mammoth (current) | ✓ clean | ✗ | ✗ | ✗ | ✓ (map) | Free | ✓ |
| mammoth + XML parsing (current hybrid) | ✓ | ✗ | ~partial | ✗ | ✓ | Free | ✓ |
| LibreOffice headless (PDF) | messy | ✓ ~85% | ✓ | ~partial | ✗ (HTML) | Free | ✓ |
| LibreOffice headless (HTML) | poor | — | CSS absolute | ~partial | ✗ | Free | ✓ |
| Pandoc | ~same as mammoth | ✗ | ✗ | ✗ | data-attr | Free | ✓ |
| Word + AppleScript | messy | ✓ 100% | ✓ | ✓ | ✗ | MS License | ✗ |
| Google Docs API | mediocre | ~80% | ~partial | ✗ | ✗ | Free tier | ✓ |
| docx4j | ~80% | ~75% (FOP) | ~partial | ✗ | ~partial | Free | ✓ |
| Aspose.Words | ✓ best | ✓ ~95%+ | ✓ (-aw-*) | ✓ SVG | ✓ | $1,175+/yr | ✓ |
| docx-preview (JS) | ~preview | ✗ | ~partial | ~partial | ✗ | Free | ✓ |
| Gotenberg (LO) | — | ✓ ~85% | ✓ | ~partial | — | Free | ✓ |
| Prince XML (HTML→PDF) | — | ✓ best CSS | — | — | — | $2,000+/yr | ✓ |
| WeasyPrint (HTML→PDF) | — | ~good | — | — | — | Free | ✓ |

---

## Recommendations by Goal

### Goal A: Maximize HTML fidelity for web-native rendering (free tools only)

**Extend the current mammoth + XML parsing hybrid:**
1. Parse `mc:AlternateContent` in the DOCX XML to extract rasterized fallback PNGs for VML shapes — this recovers the pie chart and colored squares as images.
2. Improve portrait image side-by-side layout by reading adjacent anchor positions and emitting CSS grid containers.
3. Consider contributing `wp:anchor` position exposure to mammoth.js upstream.

Ceiling: ~92–95% fidelity. The remaining gap is primarily the VML pie chart (recoverable via `mc:AlternateContent`) and exact absolute positioning that requires pixel-level comparison.

### Goal B: Maximize HTML fidelity, budget available

**Aspose.Words for Python or Node.js:**
- Provides `-aw-*` CSS positioning data for anchored images (solves the image layout problem)
- Converts VML to SVG (solves the pie chart problem)
- Preserves custom style names as CSS classes (no style map layer needed, though the style map adds semantic value)
- Single library, no external process dependency

Ceiling: ~97–99% fidelity for HTML. Combine with Playwright for PDF.

### Goal C: Maximize PDF fidelity (for print/distribution), budget available

**Aspose.Words → HTML → Prince XML:**
- Aspose.Words handles the DOCX → HTML conversion with maximum fidelity
- Prince XML handles the HTML → PDF conversion with maximum CSS Paged Media support
- Theoretical ceiling for non-Word tooling: ~98%+ vs. Word PDF

**Aspose.Words → PDF directly:**
- Aspose.Words has its own layout engine and produces PDF directly
- Likely ~95–97% fidelity vs. Word PDF, better than LibreOffice headless
- Simpler pipeline than going through HTML

### Goal D: Maximize PDF fidelity, no budget

**LibreOffice headless (--convert-to pdf) with fonts installed:**
- Install Microsoft fonts in the Docker image (`ttf-mscorefonts-installer` or MS font packages)
- Use unoserver for better throughput
- Fidelity: ~85–90% vs. Word PDF
- VML pie chart: partially rendered; test on actual EngageNY files

### Goal E: Ground-truth comparison PDFs for testing

**Word on macOS via AppleScript:**
- Generates 100% fidelity PDFs (it's Word rendering Word)
- Use for the comparison target in visual diff testing
- The EngageNY project already has canonical PDFs distributed alongside DOCXs — use those directly

---

## Key Insight: The Two Remaining Hard Problems

From the spike work, two problems remain that no free tool solves cleanly:

**Problem 1: VML Shapes (pie chart)**
The DOCX has `mc:AlternateContent` blocks containing both the VML shape and a fallback PNG. mammoth currently skips the entire `mc:AlternateContent` block. The fix is to parse this element and extract the fallback PNG — this is pure DOCX XML parsing work, no new library required.

**Problem 2: Portrait image side-by-side layout**
Word uses absolute `wp:positionH`/`wp:positionV` coordinates to place two portrait images next to each other on the same page. The DOCX XML positioning data is already being extracted (image_positions.json). The remaining work is interpreting "these two anchors have the same vertical position and adjacent horizontal positions" and emitting a side-by-side CSS grid container.

Both problems are solvable within the existing mammoth + DOCX XML hybrid approach, without introducing new dependencies. They are engineering problems, not tooling gaps.

---

## Recommended Next Steps (Ranked)

1. **[Free, 1–2 days]** Parse `mc:AlternateContent` in `extract_images.py` to recover VML fallback PNGs. This directly addresses the missing pie chart.

2. **[Free, 1–2 days]** In post-processing, detect images that share the same `positionV` and adjacent `positionH` values and wrap them in a CSS flexbox/grid container. This addresses the portrait side-by-side problem.

3. **[Low cost, 1 day]** Install MS fonts in the pipeline and test LibreOffice headless `--convert-to pdf` as an alternative PDF generation path. If fidelity is 85%+, this is a useful fallback for complex image-heavy pages.

4. **[Budget evaluation, 1 week trial]** Evaluate Aspose.Words free trial. Generate HTML from the EngageNY Lesson 4 DOCX, examine the `-aw-*` positioning data and SVG VML output. Assess whether the remaining 5% fidelity gap justifies $1,175+/year.

5. **[Long-term]** If the project scales to the full EngageNY curriculum (~1,000+ lessons), the cost per document argument changes. Aspose.Words at $1,175/year amortized over 1,000 documents is $1.18/document — potentially worth it for the fidelity gain.
