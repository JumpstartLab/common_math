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

## Development Commands

```bash
bin/rails server          # Start dev server
bin/rails db:create       # Create database
bin/rails db:migrate      # Run migrations
bin/rails test            # Run tests (minitest)
```
