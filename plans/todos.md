# CommonMath — Open Todos

*Last updated: 2026-03-25*

## Data & Content

- [ ] **Standards tagging** — Map 149 Grade 5 lessons to their CCSS standards. 110 standards (Gr 4-6) already imported. Could use AI to match lesson content against standard descriptions, or reference EngageNY's published curriculum maps.
- [ ] **Concept dependency graph** — Build prerequisite edges between standards and lessons. E.g., "5.NF.1 (add fractions) requires 4.NF.3 (understand fraction equivalence)." This is the core differentiator.
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
