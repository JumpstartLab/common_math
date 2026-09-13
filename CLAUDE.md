# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project: CommonMath

A web application that modernizes the EngageNY math curriculum (grades 4-8) as structured, navigable, web-native content — with a concept graph, vector search, Spanish translation, and mobile-friendly interface. Free tier serves as acquisition funnel for the Paper Math Companion paid app.

## Tech Stack

- **Rails 8.1** with PostgreSQL, Tailwind CSS
- **Aspose.Words** ($1,199/yr) for DOCX → HTML conversion (Python 3.13, license in scripts/)
- **pgvector** (planned) for vector embeddings alongside the relational data

## Key Directories

- `data/engageny/grade-5-html/` — 204 converted HTML files (164 MB), the entire Grade 5 curriculum
- `data/engageny/scope-and-sequence/` — Curriculum scope & sequence Word docs
- `docs/` — Concept docs, research, spike findings
- `docs/research/` — 9 research documents (competitive landscape, licensing, market, legal, etc.)
- `docs/concept-graph.md` — Specification for the mathematical concept dependency graph
- `docs/knowledge-layer.md` — Dual-layer architecture spec (structured graph + vector/LLM)
- `scripts/` — Aspose conversion scripts + license file
- `references/` — Legal documents

## Architecture Overview

```
EngageNY DOCXs → Aspose → Structured HTML → Parse/Import → PostgreSQL
                                                              ↓
                                              Concept Graph (nodes + edges)
                                              Vector Embeddings (pgvector)
                                              State Standards Crosswalk
                                              Spanish Translation Layer
                                                              ↓
                                              Rails Web App (browse/search/print)
                                              Mobile-responsive
                                              Answer checking
                                              Query router (graph → vector → LLM)
```

## Content Pipeline

1. EngageNY DOCX files converted to HTML via Aspose.Words (Grade 5 complete, Grades 4,6-8 available as ZIPs in concept-research project)
2. HTML parsed into structured data (lessons, problems, answers, strategies)
3. AI extracts concept tags and dependency edges → concept graph
4. Content embedded as vectors for fuzzy search
5. Web interface serves everything with print stylesheets

## Legal Context

- EngageNY content is CC BY-NC-SA — derivative works must be non-commercial, share-alike
- Separation agreement with Great Minds: no non-compete, non-solicitation of K-12 school/district customers until March 2027 (B2C model sidesteps this), non-disparagement
- Textbook indexing for reference (not reproduction) is fair use per Google Books precedent
- See `references/` and `docs/research/research-curriculum-licensing.md`

## State Standards (Interstandard integration)

CommonMath's own `standards` table only carries CCSS. `StateStandardTagging`
retargets those CCSS taggings onto other state frameworks (Colorado, Texas,
...) via the [Interstandard](https://github.com/JumpstartLab/interstandard)
translator API (`docs/api.md` there), and the app is browsable by state at
`/states`.

- `lib/interstandard/client.rb` — thin `Net::HTTP` client: `submit`, `fetch_report`, `poll`.
- `lib/standards/retargeter.rb` — submits every `StandardTagging`, stores confirmed `exact`/`grade_shifted` results as `StateStandardTagging` rows, marks anything no longer confirmed `stale_at` (never deletes).
- `lib/standards/coverage.rb` — the success-criterion query: fraction of a grade's lessons with a confirmed state code.

Env vars: `INTERSTANDARD_URL` (defaults to the production map), `INTERSTANDARD_API_KEY` (required to actually call out — get one at `/api_keys` on Interstandard), `INTERSTANDARD_TARGETS` (comma-separated target framework slugs, default `co-math-2020,tx-teks-math`).

Rake tasks:

```bash
bin/rails standards:retarget[co-math-2020]   # one framework
bin/rails standards:retarget_all             # every framework in INTERSTANDARD_TARGETS
bin/rails standards:coverage                 # grade 5, per framework (the success criterion)
bin/rails standards:coverage[6]              # a specific grade
bin/rails standards:coverage[all]            # every grade
```

`RetargetStandardsJob` re-runs `standards:retarget_all` weekly via Solid Queue's recurring tasks (`config/recurring.yml`), so demotions/retirements on the Interstandard side propagate without a human running the task by hand.

## Development Commands

```bash
bin/rails server          # Start dev server
bin/rails db:create       # Create database
bin/rails db:migrate      # Run migrations
bin/rails test            # Run tests (minitest)
```
