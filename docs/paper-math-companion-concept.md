# Paper Math Companion

## Core Interaction

A student is working on a paper math assignment. They use their phone or tablet (iOS) as a second screen — not as the primary learning surface, but as a support tool. The camera is the primary input: snap a photo of a problem, and the app responds.

## Use Cases

### 1. Guided Problem Solving (Student)

Student photographs a problem they're stuck on. Rather than showing the answer, the app walks them through the solution step by step — Socratic style. It prompts them to do work on paper and take follow-up photos to verify they're completing each step. The loop is:

1. Photo of problem
2. App identifies what's being asked and the concepts involved
3. App gives a hint or asks a guiding question
4. Student works on paper
5. Student photographs their work
6. App evaluates progress, gives feedback, guides next step
7. Repeat until solved

The phone is a tutor looking over your shoulder, not a calculator.

### 2. Scaffolded Practice ("More Like This")

Student identifies a problem type they're struggling with. The app either fetches from existing curriculum resources or generates on the fly a scaffolded sequence:

- Decompose the problem into its constituent concepts (A, B, C)
- Generate 1-2 problems exercising concept A alone
- Generate 1-2 problems exercising concept B alone
- Generate 1-2 problems combining A + B
- Generate 1-2 problems combining A + B + C (the full difficulty)

This is a "more like this" function that doesn't just repeat — it builds up. The problems are printed or displayed for paper work, keeping the student writing by hand.

### 3. Parent Decoder / Strategy Explorer

A parent photographs a problem their child is working on. The app identifies:

- What concepts are at play
- What strategies/techniques could solve it (with their modern names)
- Visual walkthroughs of each strategy

This bridges the gap between "I know how to multiply" and "I don't know what an area model or partial products diagram is." The parent can choose which strategy to walk through and learn alongside their child.

### 4. Textbook Reference ("Find It In Your Book")

When the app identifies a concept or strategy, it can tell the student exactly where to find it in their own textbook:

- "The strategy you need is called box multiplication. You can find it on page 56 of your Eureka Math Grade 5 textbook."
- Names the concept, names the strategy, points to the specific page/module/lesson

This never reproduces textbook content — it's a reference/citation model. The app becomes a smart index into the materials the student already has in front of them. This is a feature no competitor offers and it makes the app feel like it *knows your classroom*.

Powered by a scanned/indexed database of textbook content mapped to concepts, strategies, and page numbers.

## Key Design Principles

- **Paper is the primary learning surface.** The device is support, not replacement.
- **Camera as input.** Minimizes typing, keeps interaction fast, meets the student where they are (looking at paper).
- **Show the work.** The app should demand evidence of student effort via follow-up photos, not just serve answers.
- **Name things.** Especially for parents — surface the vocabulary and strategy names so they can participate.
- **Scaffold, don't repeat.** Practice generation should decompose and build up, not just produce more of the same.
- **Meet them in their curriculum.** Reference the student's actual textbook, not generic math content.

## Target Market

### Grade Band
- **Primary: Grades 4-8.** Captures both peak parent frustration (4-6) and the teacher-direct opportunity (6-8).
- **Secondary: Grades 9-12.** B2C/B2T channel. HS math curriculum is largely teacher-created, which means teachers have more autonomy to recommend tools and students are more likely to have phones.
- **Exclude K-3 initially.** Device access is too low and district gatekeeping is too high.

### Users
- **Students (grades 4-8)** doing paper math homework
- **Parents** trying to help with unfamiliar strategies and methods
- **Teachers** (secondary) who could recommend or integrate the tool
- **Homeschool families** — a distinct and high-value segment (see below)

### Homeschool Market

3.4-4.5M homeschool students in the US, growing ~5%/year (not reverting post-COVID). $1.46B curriculum market. Families spend $300-600/year on curriculum per child; subscriptions are fully normalized.

**Why they're ideal users:**
- Parent math anxiety is the #1 problem in grades 4-8 — they're both the teacher and the parent
- Already use EngageNY (secular, cost-conscious segment) but complain it's designed for credentialed teachers with no parent support layer — exactly the gap this app fills
- Direct-to-parent purchasing, no district gatekeeper, word-of-mouth driven
- Private tutoring averages $70-120/hour; this app at $8-12/month is a no-brainer alternative
- Synthesis Tutor ($99-120/year, K-5 AI tutor, 4.7 stars, 8K+ reviews) proves willingness to pay for AI math help

**Discovery channels:** Cathy Duffy Reviews, Well-Trained Mind forums, Facebook groups, Great Homeschool Conventions (5 regional events). Very specific, targetable, community-driven.

**Regulatory angle:** High-oversight states (NY, PA, MA, VT, RI) require documentation of standards alignment — the state standards mapping feature has real utility here.

### Go-to-Market & Funnel

**Free tier (acquisition engine):** EngageNY content modernized with AI-generated state standards alignment. Solves a real pain point for teachers ("EngageNY mapped to my state's 2026 standards"). Near-zero marginal cost to serve — OER content + one-time AI mapping per state. Spreads organically through teacher networks. Parents find it because teachers point them there.

**Paid tier ($8-12/month):** The interactive app — camera input, Socratic tutoring, scaffolded practice, parent decoder, "find it in your book." Natural upgrade when a parent is already on the platform and their kid gets stuck.

**Progression:**
1. Teacher discovers free standards-aligned content → shares with other teachers
2. Teacher recommends platform to parents for homework support
3. Parent uses free content, hits a moment where kid needs interactive help
4. Parent upgrades to paid tier for the AI tutor features

**B2B district sales only after proving scale** — avoid multi-year sales cycles early on. High school teachers making their own curriculum = B2C-friendly, no district gatekeeper.

## Competitive Landscape

The camera-solve-explain pipeline is saturated (Photomath, Mathway, Gauth). But the whitespace is significant:

| Feature | Photomath | Khanmigo | This Product |
|---------|-----------|----------|--------------|
| Camera → solve | Yes | No | Yes |
| Guided/Socratic tutoring | No (shows answer) | Yes | Yes |
| Evaluates student work (follow-up photos) | No | No | **Yes** |
| Scaffolded practice generation | No | Limited (pre-built) | **Yes** |
| Parent decoder (names strategies) | No | No | **Yes** |
| "Find it in your book" reference | No | No | **Yes** |

MagicSchool AI is teacher-facing (lesson planning, rubrics) — not in this space.

## Content Strategy

### For Prototyping (move fast, validate)
Use whatever content gets to validation fastest, regardless of licensing:
- EngageNY/Eureka Math openly available materials
- Digital textbook materials sourced from BitTorrent, library copies, etc.
- Buy physical textbooks on eBay, scan and index them

The goal is proving the interaction model, not shipping a licensed product. Replace with properly licensed content before going to market.

### For Production
- **Illustrative Mathematics (CC BY 4.0)** — best option for commercial use, explicitly permits it
- **EngageNY originals (CC BY-NC-SA)** — cannot use directly in a commercial product, but pedagogical structures and problem types are not copyrightable (only expression is)
- **Original problem generation** — AI-generated problems inspired by curriculum scope/sequence
- **Textbook indexing** — reference/citation model (point to pages, never reproduce content). Legally analogous to Google Books: scanning for indexing is fair use when you don't serve the content. Even stronger position since we'd show less than Google (page references only, no snippets).

### Textbook Index Database
Build by buying physical textbooks on secondary market (first sale doctrine), scanning pages, and creating structured mappings: curriculum → edition → grade → module → topic → lesson → page → concepts → strategies. Start with one textbook, prove it works, expand.

For grades 4-8 math, ~5-7 major curricula × 2-3 editions × 5 grade levels ≈ 50-100 textbooks. ~$500-1500 in books + weekends with a sheet-fed scanner.

## Legal Considerations

### Separation Agreement (Great Minds)
- **No non-compete.** Free to build a competing edtech product.
- **Non-solicitation (12 months, expires March 2027):** Cannot solicit GM's existing/prospective K-12 school/district customers. B2C parent/student model sidesteps this entirely.
- **Cannot provide PD services in GM curriculum (12 months).** Don't market the product as a "Eureka Math companion."
- **Confidential information:** Can't use internal GM knowledge (customer lists, pricing, roadmap). General pedagogical knowledge and publicly available content is fine.
- **Non-disparagement:** Keep the pettiness out of public statements.
- **Work product assignment only covers work done during employment.** Post-separation work is yours.

### Content Licensing
- See research-curriculum-licensing.md for full details
- Key case law: *Great Minds v. FedEx* and *Great Minds v. Office Depot* — courts ruled against GM on OER licensing questions, but those cases were about school copying, not commercial products

### Textbook Indexing
- See research-legal-indexing.md for full analysis
- **Authors Guild v. Google (2015):** Scanning entire books for search index = fair use. Our model is more conservative (page references only, no snippets)
- **Authors Guild v. HathiTrust (2014):** Showing which books contain terms and on which pages = fair use. Structurally almost identical to our approach
- Four-factor fair use analysis is strongly favorable, especially market effect (app increases textbook utility)
- Vector embeddings as "copying" is legally unsettled but intermediate copying doctrine supports fair use when no content appears in output
- Keep eBay purchase receipts as documentation of lawful acquisition

## MVP Scope

**One textbook, one module:** Eureka Math Grade 5 Module 2 (multi-digit multiplication).

This covers:
- Area models, partial products, box multiplication — the exact strategies parents don't recognize
- Peak parent frustration grade band
- ~30-40 pages to scan and index
- Rich enough to test all four use cases

Proves:
- Camera → printed problem recognition works
- Guided/Socratic walkthrough loop feels right
- Scaffolded practice generation is pedagogically useful
- "Find it on page X" textbook reference delights users
- Parents can use strategy decoder to meaningfully help

If any interaction falls flat, you find out in a week, not after scanning 100 textbooks. If they work, expanding is just more scanning and indexing, not a different product.

## Related Project: EngageNY Modernization

A separate effort to take the frozen EngageNY curriculum, parse it into structured data, modernize it with current state standards alignment, and publish it as a free web-native resource under CC BY-NC-SA. See `../engageny-modernization/concept.md`.

The modernization project feeds this app by:
- Providing the structured curriculum database this app consumes
- Building the cross-curriculum concept dictionary (canonical strategy/concept name mappings)
- Creating state standards crosswalks that power the app's alignment features
- Serving as the free tier / acquisition funnel that brings teachers and parents to the platform

## Research Documents

- `research-curriculum-licensing.md` — Licensing terms for EngageNY, Illustrative Math, OpenStax, Khan, CK-12
- `research-competitive-landscape.md` — Photomath, Mathway, Khanmigo, MagicSchool AI, gap analysis
- `research-grade-band-market.md` — Device access, curriculum purchasing, GTM models, parent involvement
- `research-legal-indexing.md` — Fair use analysis, Google Books precedent, vector embedding questions
- `research-curriculum-metadata.md` — Publicly available scope/sequence docs, market coverage, metadata gaps
- `research-eureka-math-ecosystem.md` — Zearn, EMBARC, TPT market, Duane Habecker, Khan alignment
- `research-learnzillion-case-study.md` — LearnZillion/Imagine Learning acquisition, OER business model lessons
- `research-homeschool-market.md` — Market size, curriculum purchasing, pain points, discovery channels
- `research-duane-habecker.md` — Deep profile of Duane Habecker, EMBARC co-founder, video library details

## Downloaded Resources

- `resources/engageny/grade-{4-8}/` — Complete EngageNY archive, 32 ZIP files, 3.9 GB total. Contains PDFs AND DOCX source files for every lesson, assessment, homework, and answer key.
- `resources/scope-and-sequence/` — Eureka Math scope and sequence Word docs for grades 4-8 (413K)

## Reference Documents

- `../references/great-minds-separation-agreement.pdf` — Jeff's separation agreement with Great Minds (reviewed, no red flags for this product)
