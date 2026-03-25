# CommonMath — Open Todos

*Last updated: 2026-03-25*

## Data & Content

- [ ] **Standards parsing (quick win)** — Extract CCSS codes from lesson HTML (they're in `ny-list-focusstandards` CSS classes) and create StandardTagging records linking them to lessons/topics. 110 standards already imported for Gr 4-6. This is mechanical parsing, not AI — the standards are explicitly listed in the HTML.
- [ ] **Problem extraction (core data asset)** — AI reads each problem set/exit ticket/homework HTML, identifies individual problems, extracts text/answer/type, creates Problem records. Each Problem links to its Expression records for structured math rendering. This is where we hit the formatting chaos and start normalizing. Multi-tier validation: automated structural checks → Fiverr human review. Design with validation status fields (extracted, auto_validated, human_validated).
- [ ] **Web presentation templates** — Stop serving raw Aspose HTML. Build purpose-built templates for each content type (lesson plan, problem set, exit ticket, homework) using proper web CSS with MathML from Expression records. Depends on Problem extraction to be truly useful — otherwise we're just wrapping HTML blobs. Key insight: Aspose HTML is source data, not presentation layer.
- [ ] **Standards tagging (AI-assisted)** — Beyond the explicit CCSS codes in the HTML, use AI to match lesson content against standard descriptions for deeper tagging. Builds on the mechanical standards parsing above.
- [ ] **Concept dependency graph** — Build prerequisite edges between standards and lessons. E.g., "5.NF.1 (add fractions) requires 4.NF.3 (understand fraction equivalence)." This is the core differentiator. Depends on Problem extraction + Standards tagging.
- [ ] **Inline homework/exit ticket solutions** — Currently links out to Google Drive PDFs. Fetch, parse, and render answer keys inline on lesson pages. 148 homework + 135 exit ticket solution URLs available.
- [ ] **Parent newsletter recovery** — 34 parent newsletter URLs redirect to Google sign-in (broken). Find working URLs or recreate the content.
- [ ] **Grades 4, 6-8 EngageNY content** — Convert remaining grade DOCXs through the Aspose pipeline. Source ZIPs available in concept-research project.
- [ ] **Grades 4, 6-8 EMBARC scrape** — `scripts/scrape_embarc.rb` works for any grade. Need to add course IDs for other grades and run.

## UI/UX

- [ ] **Lesson view polish** — Current views are functional but minimal. Need to look good enough to share publicly.
- [ ] **Full-text search** — Search across lessons, problem sets, and concepts. PostgreSQL full-text search as first pass, pgvector for fuzzy/semantic later.
- [ ] **Mobile-responsive layout** — Teachers browse on phones during planning. Current Tailwind layout is responsive but untested on mobile.
- [ ] **Print stylesheets** — Clean printable worksheets and lesson plans. PDF generation via `Engageny::PdfRenderer` exists but needs polish.
- [ ] **Concept graph visualization** — Interactive dependency graph. Show prerequisite chain for any topic.

## Go-to-Market

- [ ] **Publicity Phase 1: Soft launch** — Post in 2-3 Facebook groups (Eureka Math per-grade groups) and r/matheducation. Draft copy in `docs/publicity-plan.md`.
- [ ] **EMBARC outreach** — Courtesy email to EMBARC / Duane Habecker (dhabecker@gmail.com) about embedding their CC-licensed content with attribution. Draft in `docs/publicity-plan.md`.
- [ ] **Content seeding** — Write 2-3 blog posts showing specific lessons rendered on mobile. Share on #MTBoS. Post ideas in `docs/publicity-plan.md`.
- [ ] **Dan Meyer pitch** — Email after collecting initial teacher testimonials. Draft in `docs/publicity-plan.md`.
- [ ] **Podcast pitches** — Build Math Minds, Math Teacher Lounge, Math Chat. Drafts in `docs/publicity-plan.md`.
- [ ] **Tech launch** — Show HN + Product Hunt in the same week. Drafts in `docs/publicity-plan.md`.
- [ ] **Homeschool push** — Well-Trained Mind Forums, SEA Homeschoolers, Freedom Homeschooling. Time for July-August (curriculum planning season).

## Research

- [ ] **remark-math** — Evaluate https://github.com/remarkjs/remark-math for math rendering in web content. It's a remark/rehype plugin ecosystem for rendering LaTeX math syntax in Markdown/HTML via KaTeX or MathJax. Could be useful if we want to author/store math as LaTeX and render client-side, or for teacher-authored content. Compare with our current approach (MathML from Plurimath rendered natively by browsers). Key questions: do we need client-side rendering, or is server-side MathML sufficient? Does remark-math play well with Hotwire/Turbo?
- [ ] **Plurimath.js for editing** — Plurimath has a JavaScript version that could enable WYSIWYG math editing in the browser. Teachers could create exercises with a dropdown to choose math format (LaTeX, visual editor, paste from Word). We'd store as MathML. Evaluate feasibility and integration with Stimulus controllers.

## Infrastructure

- [ ] **pgvector embeddings** — Embed lesson content and concept descriptions for semantic search. PostgreSQL + pgvector already planned in the architecture.
- [ ] **Spanish translation layer** — Per `docs/engageny-modernization-concept.md`. Significant scope — probably Phase 2.
- [ ] **Deployment** — Kamal config exists (`Dockerfile`, `.kamal/`). Need to deploy to a server and point domains (common-math.org, common-math.com).

## Completed

- [x] EngageNY Grade 5 DOCX → HTML conversion (204 files via Aspose)
- [x] HTML parsing and import into Rails models (149 lessons across 6 modules)
- [x] EMBARC Grade 5 scrape — 1,194 supplemental resources catalogued and imported
- [x] YouTube video metadata — 135 lesson videos with titles/thumbnails
- [x] CCSS Math standards import — 110 standards for Grades 4-6
- [x] Khan Academy alignment — 42 links (6 modules + 36 topics)
- [x] SupplementalResource polymorphic model with EMBARC + Khan Academy sources
- [x] Lesson/topic views with video embeds and supplemental resource links
- [x] Broken link audit — 34 parent newsletter URLs identified and cleared
- [x] Publicity plan drafted — 6 phases with draft copy for each channel (`docs/publicity-plan.md`)
- [x] EMBARC extraction plan documented (`docs/embarc-extraction-plan.md`)
- [x] Domain model designed (12 tables): Grade → ContentModule → Topic → Lesson with LessonPlan, ProblemSet, ExitTicket, Homework, Assessment, Problem, Standard, Expression
- [x] HTML normalizer (Nokogiri-based) strips meaningless whitespace from Aspose output
- [x] HTML parser splits lessons into components by detecting Name/Date section boundaries
- [x] Round-trip validation: 149/149 lessons pass (normalize → split → reconstruct = original)
- [x] Browse UI: Grade → Module → Topic → Lesson with Tailwind
- [x] OMML → MathML pipeline: 13,660 expressions extracted, 13,659 converted (99.99%)
- [x] Plurimath fork (jcasimir/plurimath) with fixes for accent/overbar expressions — PRs submitted upstream
- [x] MathConverter wrapper handles project-specific edge cases (track changes, Wingdings symbols) with manifest tracking
- [x] Expression model stores OMML, MathML, text representation, and conversion status
- [x] PDF comparison tooling (pdftoppm + ImageMagick) for visual validation
- [x] Key finding: Aspose HTML is source data, not presentation layer — web templates should be purpose-built
