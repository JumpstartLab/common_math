# Curriculum Metadata Research: "Find It In Your Book" Feature

## Executive Summary

This research investigates the publicly available metadata that could power a feature telling students "The strategy you need is called box multiplication — find it on page 56 of your Eureka Math Grade 5 textbook." The conclusion is nuanced: high-level structural metadata (unit names, lesson counts, standards codes) is broadly public, but the granular page-level concept-to-location mapping that would power this feature does not exist in a ready-to-consume database. It would have to be built. However, the raw material to build it — the full PDFs of the most important curricula — is largely free and accessible.

---

## 1. Eureka Math / EngageNY

### What Exists and Where

Eureka Math is the most important curriculum to index first. It is (in various forms) the most widely used K–12 math curriculum in the country. It has a complicated provenance that actually benefits public access:

**EngageNY (the original):** The New York State Education Department commissioned and released this curriculum as a publicly funded open educational resource under a Creative Commons Attribution-NonCommercial-ShareAlike (CC BY-NC-SA) license. The original EngageNY.org was decommissioned in July 2022, but the complete archive is preserved in two places:

- **Internet Archive:** https://archive.org/details/engageny-mathematics — Complete collection of ZIP files for every grade/module from Pre-K through Grade 12 (including Algebra I, Algebra II, Geometry, Precalculus). Each ZIP contains the full module PDFs. File sizes range from ~50MB to ~315MB per module. Freely downloadable.
- **NYSED Mathematics Curriculum Files Archive:** https://www.nysed.gov/curriculum-instruction/engageny-mathematics-curriculum-files-archive — The official state-maintained archive.

**EMBARC.Online:** A community-maintained platform (https://embarc.online) serving ~30,000 daily users that provides lesson-by-lesson resources for Eureka Math. The course structure is fully public without login. For Grade 5 Module 1, for example, the module is organized into 6 topics (A–F) across 16 lessons, with each lesson catalogued by number. EMBARC provides video resources, lesson PDFs, homework solutions, exit tickets, and application problems per lesson. This is a practical way to browse the lesson structure without downloading the full module PDFs.

**Great Minds (the commercial publisher):** Great Minds commercialized Eureka Math and has produced Eureka Math² (a revised second edition). They publish:
- Free teacher/student edition PDFs for the original Eureka Math at https://greatminds.org/math/eurekamath/educators
- **State Standards Alignment Studies** — a database of 235+ free PDFs mapping Eureka Math and Eureka Math² lessons to every state's standards. These are at https://greatminds.org/standards-alignment and are publicly downloadable. The alignment studies map standards to specific module and lesson numbers (e.g., "Module 4, Lesson 17: Rewriting Square Roots"). Page numbers are not always explicit but module/lesson identifiers are.

**Khan Academy:** Mirrors the EngageNY scope and sequence with labeled exercises at https://www.khanacademy.org/math/5th-engage-ny — useful for understanding concept-to-lesson mapping.

### Structure of the Curriculum

Eureka Math organizes content as: **Grade → Module → Topic → Lesson**. Each lesson has a consistent internal structure (fluency practice, application problem, concept development, student debrief, exit ticket). The concept or strategy being taught is typically named explicitly in the lesson's "Concept Development" section.

**Modules per grade (approximate):** 5–8 modules per grade, Grades K–8. Each module contains 15–40 lessons. Total lessons across Grades 4–8: roughly 600–700 individual lessons.

The full PDFs contain exact page numbers for every concept, strategy, and example. These PDFs are freely downloadable under the CC BY-NC-SA license.

---

## 2. Illustrative Mathematics (IM)

### What Exists and Where

Illustrative Mathematics produces IM K–12 Math, an OER curriculum. Its public accessibility structure is strong but slightly gated.

**Free public access:** The curriculum is accessible at https://accessim.org (via Open Up Resources, an IM distribution partner) and at https://curriculum.illustrativemathematics.org. An account is required for full teacher materials, but the scope and sequence documents are freely downloadable without login.

**Scope and sequence PDFs (no login required):**
- K–5 Scope and Sequence: https://illustrativemathematics.org/wp-content/uploads/2021/02/v1-IM-K-5-Math-Scope-and-Sequence.pdf (33 pages)
- K–5 Beta version: https://illustrativemathematics.org/wp-content/uploads/2020/10/IM-K-5-Math-Beta-Scope-and-Sequence.pdf
- Middle School (6–8) scope and sequence visible at https://curriculum.illustrativemathematics.org/MS/teachers/1/scope_and_sequence.html
- High School (Algebra 1, Geometry, Algebra 2) scope and sequence pages also public

**Browsable lesson index (no login required):** The unit and lesson pages at curriculum.illustrativemathematics.org are publicly browsable. For example, Grade 8 Unit 4 (Linear Equations and Linear Systems) shows all 16 lesson titles organized into 4 thematic sections. No standards codes are shown in-line, but lesson titles are descriptive (e.g., "Balanced Moves," "Solving Any Linear Equation").

**Structure:** IM uses Grade → Unit → Lesson. Grades 6–8 have approximately 8–9 units per grade, with 12–20 lessons per unit. The scope and sequence for Grade 6 (Open Up Resources version) shows:
- 9 units with lesson counts and day estimates
- Unit narratives describing mathematical purpose
- Terminology introduction table (shows which lesson each term is first used)

**What's missing from public scope and sequence:** The free-access documents do not include CCSS codes per lesson or page numbers. The full standards-to-lesson mapping requires the teacher edition, which requires creating a free account on AccessIM.org.

---

## 3. Open Up Resources 6–8 Math

Open Up Resources distributes the IM 6–8 curriculum under its own branding. Grade-level scope and sequence pages are completely public at https://access.openupresources.org/curricula/our6-8math-v3/:

- Grade 6: https://access.openupresources.org/curricula/our6-8math-v3/en/default/grade-6/course_guide/scope-and-sequence.html
- Grade 7 and Grade 8: same pattern

These pages include unit names, lesson counts, pacing in days, unit narratives, and a terminology introduction table per lesson. Standards codes are absent.

---

## 4. Bridges in Mathematics

Published by The Math Learning Center. Multiple editions of scope and sequence documents are freely downloadable as PDFs directly from mathlearningcenter.org:

- Pre-K through Grade 5 (2nd Edition): Available individually at https://www.mathlearningcenter.org/sites/default/files/documents/ScopSeq-GR[0-5].pdf
- 3rd Edition Grade 3: https://www.mathlearningcenter.org/sites/default/files/documents/third-ed/3br3-scopeseq.pdf

These PDFs organize content by unit and session (their term for lesson), including session names and the standards addressed. This is among the more granular public scope and sequence documentation available.

---

## 5. Other Major Curricula — Public Access Summary

### enVision Mathematics (Savvas/Pearson)
- Marketed as "the nation's most popular math program"
- Scope and sequence overview exists but is behind the Savvas training portal (mysavvastraining.com)
- Some district-published scope and sequence documents (e.g., one district's Grade 5 enVision Scope & Sequence) are findable via search — districts sometimes post these as PDFs on their websites
- EdReports review at https://edreports.org/reports/overview/envision-mathematics-common-core-2024 provides grade-level quality ratings but no lesson-level index
- No public bulk download of lesson/concept metadata; accessing this would require publisher cooperation or manual extraction from commercial materials

### Go Math (HMH / Houghton Mifflin Harcourt)
- No public scope and sequence documents of significant granularity found
- District-published pacing guides referencing Go Math are occasionally findable
- Commercial materials; not OER

### Saxon Math (HMH)
- HMH publishes official K–8 scope and sequence brochures publicly: https://www.hmhco.com/~/media/sites/home/education/global/pdf/scope-and-sequence/mathematics/elementary/saxon-math/scope-and-sequence-6-14-13.pdf
- Additional Saxon scope and sequence documents available at various state education department mirror sites
- These documents organize content by lesson number and topic strand (Numbers and Operations, Geometry, Measurement, etc.) across grade levels — useful for high-level concept mapping but not page-level

### Big Ideas Math (Big Ideas Learning)
- No publicly accessible scope and sequence documents found
- Commercial product with gated digital access

### CPM (College Preparatory Mathematics)
- Free open-access version of materials available at cpm.org for some courses
- Table of contents and chapter structure browsable on their site
- Used primarily in middle and high school (grades 6–12)
- No bulk metadata download found

### Fishtank Learning (free, not widely adopted as a primary curriculum)
- Fully public curriculum at fishtanklearning.org
- 200+ units and 4,000+ lessons for K–8 math, free with account (no-cost, permanent)
- Full lesson titles, unit names, and standards codes are listed publicly
- OER licensed (CC BY-NC-SA)
- Less likely to be the "textbook" a student is using but could be indexed as a reference

### Zearn Math
- Derivative of Eureka Math / EngageNY for K–5
- State standards alignment documents freely downloadable per state (e.g., https://webassets.zearn.org/resources/ZearnStateStandards_Louisiana.pdf)
- These PDFs map each Zearn lesson to specific state standards

---

## 6. State Education Department Resources

### EngageNY / NYSED (New York)
New York's NYSED published a Guide for Aligning Local Curricula to the Next Generation Mathematics Learning Standards (https://www.nysed.gov/sites/default/files/curriculum-alignment-guide-mathematics.pdf), which is a framework document rather than a textbook index.

### Louisiana Department of Education
Louisiana is considered the national leader in curriculum quality mandates. The LDOE publishes:
- Annotated curriculum reviews at https://doe.louisiana.gov/school-system-leaders/instructional-materials-reviews/curricular-resources-annotated-reviews
- Video lesson information documents for IM Grades 6–8 and Algebra I (free PDF)
- Detailed state-specific curriculum guides that sometimes include lesson-level information

### California Department of Education
California's 2023 Mathematics Framework (https://www.cde.ca.gov/ci/ma/cf/) is a comprehensive policy document. The CDE maintains an approved instructional materials list but does not publish page-level alignment maps.

### Rhode Island Department of Education
RIDE publishes an annual Curriculum Survey report and an interactive visualization tool showing exactly which curriculum each LEA is using for math: https://ride.ri.gov/instruction-assessment/curriculum/curriculum-used-rhode-island. This is the most thorough state-level adoption tracking database found in this research.

### District-Level Pacing Guides
Many districts publish pacing guides publicly on their websites. These vary enormously in granularity:
- Some are "Year at a Glance" documents (weekly topic overview, very coarse)
- Better ones include lesson numbers, standards codes, and textbook section references
- Examples of districts with public pacing guides: Clark County (NV), St. Johns County (FL), Fort Mill SD4 (SC), Rankin County (MS), Cherokee County (GA)
- These are findable but not aggregated anywhere; would require systematic crawling

---

## 7. Standards Alignment Data and APIs

### Common Core State Standards (CCSS)
- Full text available at https://www.thecorestandards.org/Math/ and as PDF from CCSSO
- The standards themselves are public domain
- The standard identifiers (e.g., 5.NBT.B.7) are the primary cross-referencing mechanism used across all curricula

**Achieve the Core Coherence Map:** https://tools.achievethecore.org/coherence-map — An interactive tool showing prerequisite relationships between CCSS math standards. Built as a Flash application (now running via Ruffle emulator). Shows how standards build on each other across grades but does not map standards to specific textbook pages.

### Common Standards Project API
- GitHub: https://github.com/commonstandardsproject/api
- Live API at api.commonstandardsproject.com (requires free API key)
- Provides JSON-formatted standards data for all 50 states plus CCSS
- Data is sourced from ASN (Achievement Standards Network) and reformatted for edtech use
- Each standard has a unique GUID; can retrieve all standards for a subject/grade as JSON
- Coverage: standards documents and individual standard statements with codes and descriptions
- Does NOT include any mapping to curriculum materials or textbook locations

### Achievement Standards Network (ASN)
- Operated by D2L (Desire2Learn): http://asn.desire2learn.com
- Machine-readable RDF/XML representations of K–12 standards from all states
- Each standard statement has a unique URI
- Provides cross-state standards alignment mappings (mapping one state's standards to another)
- Does NOT include curriculum or textbook location data
- Free access to standards data; primarily used for LMS integration

### SirFizX GitHub: JSON Common Core Standards
- https://github.com/SirFizX/standards-data
- Simple JSON representations of CCSS math and ELA standards
- No curriculum alignment; standards text and codes only

### Great Minds State Alignment Studies (235+ documents)
- https://greatminds.org/standards-alignment
- The most useful publicly available standards-to-curriculum mapping found
- 235 free PDF documents covering Eureka Math, Eureka Math², PhD Science, Wit & Wisdom, Arts & Letters
- Maps state standards to specific module and lesson identifiers
- Granularity: standard → "Module X, Lesson Y" (sometimes with notes on whether the standard is fully addressed)
- Page numbers within lessons are NOT included, but module/lesson is sufficient for many use cases
- Format is PDF only; no structured data download

---

## 8. Existing Services with Cross-Curriculum Functionality

### EdReports.org
- https://edreports.org
- Provides detailed criterion-based curriculum quality reviews for most major curricula
- Reviews evaluate alignment to standards at the grade level and program level
- Granularity: program-level and grade-level judgments — does NOT map individual concepts to specific lessons or pages
- No API or bulk data download; web interface only
- Updated their review criteria in January 2025 (Version 2.0)
- Useful for: understanding which curricula are well-aligned to CCSS; not useful for building a concept index

### Kiddom
- https://www.kiddom.co
- A digital curriculum platform that has licensed IM, EL Education, and other curricula
- Standards are integrated per-lesson in their platform
- Has lesson-level standards mapping but this is internal platform data, not public
- Their curriculum delivery is standards-tagged but the data is not exported or accessible externally

### Khan Academy
- Has created its own curriculum aligned to CCSS and also mirrors EngageNY structure
- Lesson titles and standards codes are public on the website
- Not a direct "find it in your book" service but provides a concept-name → standard mapping that could be useful as a cross-reference layer
- For example: searching "box multiplication" or "partial products" on Khan Academy leads to labeled lessons that cite which CCSS standard they address

### Zearn Math
- Built on Eureka/EngageNY scope and sequence for K–5
- Standards alignment documents per state are freely downloadable
- Not a "find it in your textbook" service, but the state alignment PDFs show Zearn lesson number → state standard mapping

### OER Commons
- Hosts a curated EngageNY collection at https://oercommons.org/curated-collections/127
- Resources are tagged with CCSS codes, making them searchable by standard
- Browsable by grade and standard but not a concept-name search

### No Direct Equivalent Found
No existing public service was found that implements the specific "photograph a problem → identify the strategy → locate it in [specific textbook]" workflow. The closest analogues are:
- Quizlet textbook solutions (matches problems to solutions, not strategies to curriculum locations)
- Khan Academy (maps concepts to standards but not to physical textbook pages)
- Great Minds' own help center (links Eureka lessons to their curriculum but only for Eureka)

---

## 9. Market Scale: How Many Curricula to Cover 80% of Students (Grades 4–8)?

### Market Structure
The K–12 math curriculum market is fragmented. No single curriculum reaches a majority of students nationally. Key data points:

**The "Big Three" publishers** (McGraw-Hill, Houghton Mifflin Harcourt/HMH, and Savvas) control approximately 61% of elementary curriculum selections and 67% of middle school curriculum selections, per CEMD data on 934 districts covering 52%+ of U.S. students.

**Dominant curricula by adoption:** Based on available data from CEMD (2024–25), RAND AIRS surveys, EdWeek reporting, and independent surveys:

| Curriculum | Publisher | Estimated Reach | Public Metadata |
|---|---|---|---|
| Eureka Math / EngageNY | Great Minds | Largest single K–5 program nationally; described as most-used K–5 | Full PDFs free (CC BY-NC-SA) |
| Illustrative Mathematics (IM) | IM / various partners | 5.3 million students (CEMD 2024–25); 250+ districts | Scope/sequence public; full text with free account |
| enVision Mathematics | Savvas | "Nation's most popular" (self-described); ~20%+ in some regions | No public full text |
| Go Math | HMH | High adoption in western states | No public full text |
| Bridges in Mathematics | Math Learning Center | Substantial elementary adoption | Scope/sequence PDFs public |
| i-Ready Math | Curriculum Associates | Growing rapidly (~8 teacher votes in Pershan survey) | No public full text |
| Big Ideas Math | Big Ideas Learning | Middle/high school focus | No public full text |
| Saxon Math | HMH | Strong in homeschool and some districts | Scope/sequence public; full text behind paywall |
| CPM | CPM | Middle/high school, CA and Pacific NW | Some free online access |
| Fishtank Learning | Match Education | Small but growing; free OER | Fully public |

**For 80% coverage of Grades 4–8 students (rough estimate):** Indexing 5–6 curricula would likely cover most of the market — specifically Eureka Math/EngageNY, Illustrative Mathematics, enVision, Go Math, Bridges, and i-Ready. The challenge is that 3 of these (enVision, Go Math, i-Ready) have no publicly accessible full text; they would require publisher agreements.

### Edition Churn
Textbook editions typically change every 3 years at the publisher level, though school adoption cycles run 5–7 years. This means at any given time, multiple editions of the same curriculum are in active use simultaneously. For Eureka Math specifically, schools may be using:
- Original EngageNY (2013, still widely in use)
- Eureka Math 1st Edition (2015–2021)
- Eureka Math² (2021+, substantially revised)

Each edition has different page numbers and sometimes different module/lesson structures. An indexing system would need to track edition as a key metadata field.

### State Adoption Patterns
The market is highly regional:
- Northeast and Mid-Atlantic: high Eureka/EngageNY adoption
- South: enVision strong
- West: Go Math has been dominant; IM gaining rapidly
- California: IM gaining after 2023 framework approval; enVision also strong
- Midwest: mixed

---

## 10. Practical Assessment: What Can Be Built and How

### Immediately Actionable (Free, OER Sources)

The following curricula have sufficient public metadata to begin building an index today:

**Eureka Math / EngageNY (Grades K–8)**
- Full PDFs available free from Internet Archive (CC BY-NC-SA)
- Strategy/concept names appear explicitly in lesson PDFs ("Concept Development" sections)
- Module → Topic → Lesson structure is consistent
- Great Minds alignment study PDFs provide standard → lesson mapping for all 50 states
- Building a lesson-level concept index would require PDF parsing of ~150 module files

**Illustrative Mathematics (Grades 6–12)**
- Lesson titles publicly browsable without login
- Full lesson text accessible with free account on accessim.org
- No stated restriction on using the content for a reference tool (CC BY 4.0 licensed)
- Standards codes appear in lesson materials
- Lesson titles are descriptive enough to enable concept matching

**Bridges in Mathematics (Grades K–5)**
- Scope and sequence PDFs freely available
- Full curriculum materials require account with Math Learning Center
- Less useful without the full PDFs

**Open Up Resources 6–8 (same content as IM 6–8)**
- Scope and sequence with terminology-per-lesson table is public
- Full access via account at access.openupresources.org

**Saxon Math K–8**
- Scope and sequence publicly available from HMH
- Lesson-level content not free but scope is sufficient for high-level concept mapping

### Requires Publisher Agreement

- enVision Mathematics (Savvas)
- Go Math (HMH)
- i-Ready Math (Curriculum Associates)
- Big Ideas Math
- Math in Focus (Singapore approach, HMH)

### Structural Gaps in Existing Metadata

Even for the OER curricula, the existing public metadata has significant gaps:

1. **No canonical concept name database** — Curricula use different names for the same strategy (Eureka calls it "partial products algorithm" and uses area models; another curriculum may call it "box method"). No public crosswalk between these naming conventions exists.

2. **No page-number metadata in structured form** — Great Minds alignment studies give module/lesson but not page numbers within lessons. Getting exact page numbers requires parsing the PDFs.

3. **No cross-curriculum concept equivalency mapping** — There is no public database saying "what Eureka calls Topic F Lesson 13 is the same concept as what enVision calls Topic 3 Lesson 3."

4. **Coherence Map (Achieve the Core)** — Shows standard-to-standard prerequisite relationships but not curriculum locations.

---

## 11. Key Sources and Links

### Full Curriculum Archives
- Internet Archive EngageNY: https://archive.org/details/engageny-mathematics
- NYSED Archive: https://www.nysed.gov/curriculum-instruction/engageny-mathematics-curriculum-files-archive
- OER Commons EngageNY collection: https://oercommons.org/curated-collections/127
- Access IM (Illustrative Mathematics): https://accessim.org
- Open Up Resources curriculum access: https://access.openupresources.org/curricula
- Fishtank Learning: https://www.fishtanklearning.org/curriculum/math/

### Scope and Sequence Documents
- IM K–5 Scope and Sequence PDF: https://illustrativemathematics.org/wp-content/uploads/2021/02/v1-IM-K-5-Math-Scope-and-Sequence.pdf
- Open Up Resources Grade 6 Scope and Sequence: https://access.openupresources.org/curricula/our6-8math-v3/en/default/grade-6/course_guide/scope-and-sequence.html
- Bridges Grade 3 Scope and Sequence: https://www.mathlearningcenter.org/sites/default/files/documents/ScopSeq-GR3.pdf
- Saxon Math K–8 Scope and Sequence: https://www.hmhco.com/~/media/sites/home/education/global/pdf/scope-and-sequence/mathematics/elementary/saxon-math/scope-and-sequence-6-14-13.pdf

### Standards Alignment
- Great Minds Alignment Studies: https://greatminds.org/standards-alignment
- Common Standards Project API: https://github.com/commonstandardsproject/api
- Achievement Standards Network: http://asn.desire2learn.com
- Achieve the Core Coherence Map: https://tools.achievethecore.org/coherence-map
- CCSS Mathematics text: https://www.thecorestandards.org/Math/

### Market Research
- CEMD "Learning by the Book": https://cepr.harvard.edu/curriculum
- EdWeek/CEMD database article: https://www.edweek.org/teaching-learning/are-schools-choosing-high-quality-math-curricula-a-new-database-offers-clues/2023/10
- Michael Pershan curriculum survey: https://pershmail.substack.com/p/what-is-the-most-popular-elementary
- RAND American Instructional Resources Survey: https://www.rand.org/education-and-labor/projects/american-mathematics-educator-study.html
- Rhode Island adoption database: https://ride.ri.gov/instruction-assessment/curriculum/curriculum-used-rhode-island

### Community Platforms
- EMBARC.Online (Eureka/EngageNY lesson browser): https://embarc.online
- Khan Academy EngageNY alignment: https://www.khanacademy.org/math/5th-engage-ny
- EdReports reviews: https://edreports.org/reports
