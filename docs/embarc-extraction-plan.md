# EMBARC Grade 5 Extraction Plan

*Created: 2026-03-24*

## What EMBARC Has for Grade 5

### Structure

- **1 General Resources page** — pacing guides, standards docs, vocabulary cards, number talks, lesson plan templates
- **6 Modules** (M1–M6), each containing:
  - Module-level resources (Eureka Essentials, fluency games, downloadable teacher editions, application problems)
  - Topics (A through F/G/H depending on module), each with:
    - Parent newsletter (external URL)
    - SMARTboard files
    - Topic quiz (Google Doc link)
  - Lessons (varies per module — M1 has 16 lessons, M4 has 33), each with:
    - Video (embedded, format TBD — need browser rendering to confirm)
    - Lesson PDF
    - Homework Solutions (Google Drive links)
    - Promethean Flipchart
    - Google Slides presentation
    - Exit Ticket Solutions
    - Go Formative Exit Ticket
  - Mid-module review
  - End-of-module review
  - Occasional extras: GeoGebra applets, online practice quizzes

### Estimated Volume

| Module | Lessons | Topics |
|--------|---------|--------|
| M1: Place Value and Decimal Fractions | 16 | 6 (A-F) |
| M2: Multi-Digit Whole Number and Decimal Fraction Operations | ~29 | TBD |
| M3: Addition and Subtraction of Fractions | ~22 | TBD |
| M4: Multiplication and Division of Fractions and Decimal Fractions | 33 | 8 (A-H) |
| M5: Addition and Multiplication with Volume and Area | ~21 | TBD |
| M6: Problem Solving with the Coordinate Plane | ~33 | TBD |

**Per lesson, ~7 resources. Across ~150+ lessons, that's ~1,000+ individual resource pages.**

### Content Format Reality

Most EMBARC content is **not hosted on the Moodle site itself**. The Moodle pages are thin wrappers pointing to external resources:

| Resource Type | Actual Format | Where It Lives |
|---------------|--------------|----------------|
| Topic Quizzes | Google Docs | Google Drive (shared links) |
| Homework Solutions | PDFs/Docs | Google Drive (shared links) |
| Google Slides | Google Slides | Google Drive (shared links) |
| Videos | Embedded players | YouTube/Vimeo (need to confirm) |
| Lesson PDFs | PDF files | Likely Google Drive or Moodle file storage |
| GeoGebra Applets | Interactive embeds | GeoGebra.org |
| Promethean Flipcharts | Proprietary format | Moodle file storage (`.flipchart` files) |
| Parent Newsletters | External URLs | Various (Google Docs, etc.) |
| Pacing Guides | Google Docs | Google Drive |
| Exit Ticket Solutions | Unknown | Google Drive or Moodle |

### Key Contact

Quizzes and homework solutions reference **Duane Habecker** (dhabecker@gmail.com) as the author/maintainer — he appears to be a primary content contributor.

---

## What's Worth Extracting

### High Value for CommonMath

1. **Homework Solutions** — Answer keys that supplement the EngageNY content. Parents and teachers need these.
2. **Exit Ticket Solutions** — Quick assessment answers, useful for the answer-checking feature.
3. **Topic Quizzes** — Additional assessment content beyond what EngageNY provides.
4. **Pacing Guides** — Inform our navigation/recommended paths (which lessons to combine, skip, or emphasize).
5. **Parent Newsletters** — Per-topic summaries explaining what kids are learning and how parents can help. Gold for the B2C homeschool audience.
6. **Video links** — We don't need to host the videos, just extract and embed the YouTube/Vimeo URLs alongside our lesson content.
7. **GeoGebra applet links** — Interactive tools we can embed or link to per lesson.
8. **Customizing/omitting/condensing guides** — Teacher wisdom about which content is essential vs. optional.

### Lower Value / Skip

- **Promethean Flipcharts** — Proprietary format for interactive whiteboards. Not useful for web.
- **SMARTboard files** — Same issue, proprietary IWB format.
- **Go Formative Exit Tickets** — Likely links to the GoFormative platform (now Formative), may require accounts.

---

## Extraction Strategy

### Phase 1: Scrape the Moodle Structure

Build a scraper that walks the EMBARC Moodle site and extracts the **link graph** — every module, topic, lesson, and resource URL. This gives us:

- The complete sitemap of Grade 5 content
- All external URLs (Google Drive, YouTube, GeoGebra, etc.)
- The organizational hierarchy (module → topic → lesson → resource)

**Technical approach:**
- EMBARC's Moodle pages are public (no login required for viewing)
- URLs follow predictable Moodle patterns: `/course/view.php?id=N`, `/mod/page/view.php?id=N`
- Parse each course page for section headers and resource links
- Parse each resource page for the actual content URL (Google Drive link, YouTube embed, etc.)
- Store as structured JSON

**Rate limiting:** Be respectful — 1 request per second, run during off-peak hours. These are teacher volunteers running this site.

```
Output structure:
{
  "grade": 5,
  "modules": [
    {
      "number": 1,
      "title": "Place Value and Decimal Fractions",
      "embarc_url": "https://embarc.online/course/view.php?id=3",
      "resources": [...],
      "topics": [
        {
          "letter": "A",
          "title": "Multiplicative Patterns on the Place Value Chart",
          "parent_newsletter_url": "...",
          "quiz_url": "...",
          "lessons": [
            {
              "number": 1,
              "video_url": "...",
              "lesson_pdf_url": "...",
              "homework_solutions_url": "...",
              "google_slides_url": "...",
              "exit_ticket_solutions_url": "...",
              "extras": [...]
            }
          ]
        }
      ]
    }
  ]
}
```

### Phase 2: Fetch External Content

Once we have all the Google Drive/Docs links, fetch the actual content:

1. **Google Docs (quizzes, pacing guides)** — Export as HTML or plain text via Google Drive API or direct export URLs (`/export?format=html`)
2. **Google Drive PDFs (homework solutions)** — Download and parse, or use the same Aspose pipeline we already have
3. **YouTube videos** — Extract video IDs for embedding (don't download the videos)
4. **GeoGebra applets** — Extract applet IDs/URLs for embedding

### Phase 3: Parse and Structure

Transform extracted content into the same structured format as our EngageNY content:

- Quiz questions → problem/answer pairs
- Homework solutions → answer keys linked to specific lesson problems
- Pacing guides → metadata on lesson groupings and priorities
- Parent newsletters → topic summaries

### Phase 4: Import into CommonMath

- Associate EMBARC resources with existing EngageNY lessons by module/topic/lesson number
- Render supplemental content alongside the primary curriculum
- Add EMBARC attribution on every page that includes their content

---

## Mapping EMBARC to EngageNY Content

The mapping is straightforward because EMBARC mirrors EngageNY's structure exactly:

```
EngageNY Grade 5, Module 1, Topic A, Lesson 1
    ↔
EMBARC Grade 5, Module 1, Topic A, Lesson 1
```

Each EMBARC lesson corresponds 1:1 to an EngageNY lesson. The module numbers, topic letters, and lesson numbers are identical. This means we can join on `(grade, module, topic, lesson)` with high confidence.

---

## Licensing & Attribution

**License:** CC BY-NC-SA 4.0 (same as EngageNY)

**Required attribution:** "This work by EMBARC.Online based upon Eureka Math and is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License."

**Our attribution plan:**
- Footer or sidebar note on any page displaying EMBARC content: "Supplemental materials from EMBARC.Online, licensed under CC BY-NC-SA 4.0"
- Link back to the specific EMBARC page for each resource
- Acknowledgment on our About/Credits page

**Non-commercial constraint:** Same constraint we already operate under with EngageNY. Free tier only. Paper Math Companion must use only original content.

---

## Implementation Sequence

- [ ] **Step 1:** Write the Moodle structure scraper (Python or Ruby script)
- [ ] **Step 2:** Run it against Grade 5 modules 1-6, output JSON sitemap
- [ ] **Step 3:** Manual review of the sitemap — verify completeness, identify broken links
- [ ] **Step 4:** Write Google Drive content fetcher for docs/PDFs
- [ ] **Step 5:** Extract video URLs (YouTube IDs) from video pages (may need browser rendering)
- [ ] **Step 6:** Parse quiz content from Google Docs into structured problem/answer format
- [ ] **Step 7:** Parse homework solutions into answer keys
- [ ] **Step 8:** Build Rails import task that associates EMBARC content with EngageNY lessons
- [ ] **Step 9:** Update views to display supplemental content with attribution
- [ ] **Step 10:** Send courtesy email to EMBARC / Duane Habecker letting them know

---

## Open Questions

1. **Video hosting** — Are the lesson videos on YouTube (embeddable) or self-hosted on Moodle (harder to extract)?
2. **Google Drive permissions** — Are all the shared links set to "anyone with the link"? Some may be restricted.
3. **Content freshness** — Some homework solutions were last modified in 2017. Is newer content available?
4. **Modules 2, 3, 5, 6** — Need to inventory these to confirm they follow the same structure as M1 and M4.
5. **GoFormative exit tickets** — Worth extracting? They may require platform accounts.
