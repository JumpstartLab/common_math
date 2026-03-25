# EngageNY Modernization Project

A separate effort from the Paper Math Companion app. Takes the frozen-in-2022 EngageNY curriculum, transforms it into structured data, modernizes it with current state standards alignment, and publishes it as a free, open, web-native resource.

## The Problem

EngageNY is pedagogically excellent math curriculum, used by millions of students, but:
- The website shut down in 2022 — content exists only as archived ZIP files of PDFs/DOCXs on Internet Archive
- Standards alignment is frozen at the original Common Core mapping — many states have since revised, renamed, or replaced their standards
- The content is not structured data — it's documents, not a queryable database
- No one has modernized it because it's a massive, unglamorous effort
- Great Minds commercialized it as Eureka Math / Eureka Math Squared, but the original OER content remains freely available under CC BY-NC-SA

## The Vision

A modern, web-native, freely accessible version of EngageNY that is:
- **Structured as data** — every lesson, concept, strategy, standard parsed into queryable form
- **Browsable on the web** — proper interface with print stylesheets (paper-first philosophy)
- **Aligned to current state standards** — not just Common Core, but each state's 2026+ framework
- **Living, not frozen** — community-maintained with teacher contributions
- **Protected by license** — CC BY-NC-SA, same as the original, preventing commercial co-opting

## Implementation Pipeline

### Phase 1: Parse into Structured Data
- **Tooling decision (2026-03-24): Aspose.Words for Python** ($1,199/yr). Evaluated against mammoth, Pandoc, LibreOffice, and others. Aspose achieves ~99% visual fidelity including image positioning, VML shapes, headers/footers. See `../paper-math-companion/spikes/docx-roundtrip/SPIKE.md` for full evaluation.
- Extract DOCX files from the EngageNY archive (we have grades 4-8, all modules)
- Aspose outputs HTML with `position: absolute` and `-aw-` CSS properties — preserves Word's exact layout
- Parse each lesson into structured components: objectives, standards, vocabulary, strategies, problem sets, homework, assessments, answer keys
- Build a machine-readable database — the first of its kind for this curriculum
- Tag concepts and strategies with canonical names

### Phase 2: Web Interface
- Build a proper web application to browse and navigate the curriculum
- Print stylesheets so teachers and parents can produce clean paper materials
- Search by concept, standard, grade, module, topic, lesson
- Mobile-friendly (parents accessing on phones)

### Phase 3: State Standards Crosswalk
- Map current state standards to their closest Common Core equivalents
- Start with high-population states and states that have diverged most from CCSS
- Create a navigation layer: pick your state → see the curriculum mapped to your standards
- AI does the initial mapping; humans review and validate

### Phase 4: Alignment Quality Assessment
- For each state standard → CCSS mapping, assess match quality (tight, approximate, gap)
- Flag where a state standard has no good equivalent in the existing content
- Flag where existing content covers something no longer in the state standards
- Publish the quality scores transparently

### Phase 5: Content Revision
Two parallel tracks:
- **AI-generated revisions** where alignment is close but metadata/framing needs updating
- **Teacher bounty system** where educators are paid to rewrite and review curriculum elements where alignment is loose or gaps exist

### Phase 6: Eureka Math Squared Coverage
- Duane Habecker's videos cover original Eureka Math but NOT Eureka Math Squared
- EMBARC hasn't fully adapted either
- The modernization project could fill this gap with new content aligned to the updated scope and sequence

## Licensing Strategy

The original EngageNY is **CC BY-NC-SA 3.0/4.0**. The ShareAlike clause requires derivative works to carry the same (or compatible) license. This is a feature, not a bug:

- All modernized content is released as **CC BY-NC-SA 4.0**
- Anyone can use it freely for non-commercial purposes (teachers, schools, homeschool families)
- **No one can commercialize it** — not Great Minds, not anyone else
- The NC clause prevents a company from printing and selling it
- The SA clause prevents anyone from taking improvements and closing them off
- This is the same defensive licensing model used by Wikipedia, Linux kernel (GPL), and other successful open projects

**The strategic play:** This free, modernized curriculum becomes the top-of-funnel for the Paper Math Companion app. Teachers and parents come for the free standards-aligned content, stay for the paid interactive tutoring features.

## Business Model

The modernization project itself is not a revenue generator — it's:
1. **A public good** that builds reputation and goodwill in the education community
2. **An acquisition engine** for the Paper Math Companion paid app
3. **A platform for community** — teachers contributing and reviewing builds engagement
4. **A data asset** — the structured curriculum database and standards crosswalk are infrastructure that powers the paid product

The teacher bounty system could be funded from Paper Math Companion subscription revenue once that's generating income.

## Scale Estimate

EngageNY grades 4-8:
- 32 modules across 5 grades
- Estimated 600-800 individual lessons
- Each lesson needs: parsing, concept tagging, standards mapping, quality assessment
- 50 states × hundreds of standards = large crosswalk matrix, but highly automatable

The DOCX source files make parsing dramatically easier than working from PDFs. We have them all downloaded.

## Concept Graph — The Core Data Layer

See `concept-graph.md` for the full specification.

A directed graph of mathematical concepts connecting every piece of content. Nodes are concepts/skills, edges are dependencies, and every lesson/problem/assessment links to the concepts it teaches or requires. This doesn't exist anywhere — it's the most valuable and defensible asset in the project.

Enables: test question → source lessons, "I'm stuck" → prerequisite identification, scaffolded practice decomposition, cross-grade dependency tracing, parent strategy decoder, and the Spanish translation layer (concepts are language-independent, only labels need translation).

Built by: AI extraction from structured lesson data (objectives, vocabulary, teacher scripts, problem sets), validated by teacher bounty reviewers, cross-referenced with scope & sequence docs and CCSS standards.

Estimated scale: ~200-400 concept nodes, ~500-1,000 edges, ~6,000-10,000 tagged problems across grades 4-8.

## Integrated Architecture

```
┌─────────────────────────────────────────────────┐
│              EngageNY DOCX Files                │
│          (3.9 GB, 1,368 files, grades 4-8)      │
└──────────────────────┬──────────────────────────┘
                       │ Aspose.Words ($1,199/yr)
                       ▼
┌─────────────────────────────────────────────────┐
│            Structured Content Database           │
│  Lessons, problems, answers, strategies, images  │
│  ~500 MB HTML / ~200 MB text + ~300 MB images    │
└───────┬──────────────┬──────────────┬───────────┘
        │              │              │
        ▼              ▼              ▼
┌──────────────┐ ┌───────────┐ ┌──────────────────┐
│ Concept Graph│ │  Spanish  │ │  State Standards  │
│ ~300 nodes   │ │Translation│ │    Crosswalk      │
│ ~800 edges   │ │  Layer    │ │   50 states       │
│ ~8K tagged   │ │ (AI + human│ │  (AI + human     │
│  problems    │ │  review)  │ │   review)         │
└──────┬───────┘ └─────┬─────┘ └────────┬─────────┘
       │               │                │
       └───────────────┼────────────────┘
                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
┌──────────────────┐    ┌─────────────────────────┐
│   Free Web App   │    │  Paper Math Companion    │
│                  │    │    (Paid, $8-12/mo)      │
│ • Browse content │    │                         │
│ • Search by      │    │ • Camera input          │
│   concept/std    │    │ • Socratic tutoring     │
│ • Print sheets   │    │ • Scaffolded practice   │
│ • Mobile view    │    │ • "Find it in your book"│
│ • Spanish toggle │    │ • Parent decoder        │
│ • Type answers   │    │ • Handwriting eval      │
│   for checking   │    │ • Progress tracking     │
│                  │    │ • Concept gap analysis   │
│ (acquisition     │    │                         │
│  funnel)         │    │ (revenue engine)        │
└──────────────────┘    └─────────────────────────┘
```

The concept graph is the shared brain. Both products query it. The free web app is the acquisition funnel that brings users in. The paid app is the tutoring layer that monetizes.

## Relationship to Paper Math Companion

These are converging projects that share:
- The same EngageNY source materials (already downloaded)
- The structured curriculum database (built by Aspose conversion)
- **The concept graph** (the shared brain — concept nodes, dependency edges, problem tags)
- The cross-curriculum concept dictionary (aliases across curricula)
- The state standards crosswalk
- The Spanish translation layer
- The user base (teachers and parents)

They differ in:
- **Interface:** Web app (browse/search/print/type) vs. iOS app (camera/AI/handwriting)
- **Business model:** Free/open vs. freemium subscription
- **User moment:** "I'm preparing" vs. "I'm stuck right now"
- **Complexity:** The web app can ship incrementally; the iOS app needs more foundation

## Key Resources

- EngageNY archive: `../paper-math-companion/resources/engageny/` (3.9 GB, grades 4-8)
- Scope and sequence: `../paper-math-companion/resources/scope-and-sequence/`
- EMBARC.online — community resource serving 30K users/day, potential collaborator
- Duane Habecker — co-founded EMBARC, 133K YouTube subscribers, reachable and likely aligned

## Open Questions

- What's the right technology stack for the web interface? Static site generation vs. dynamic app?
- How to structure the teacher bounty system — fixed per-lesson rates, quality tiers, review process?
- Which states to prioritize for standards mapping? (Population × divergence from CCSS)
- Could this be a nonprofit or foundation rather than a company project?
- Relationship with EMBARC — collaborate, absorb, or parallel track?
