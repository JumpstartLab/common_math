# EMBARC Grade 5 Scrape Analysis

*Completed: 2026-03-24*

## Scrape Summary

- **1,201 HTTP requests** across 7 modules (structure + deep content URL extraction)
- **1,194 total resources** catalogued
- **1,012 resources (85%)** have extracted content URLs pointing to external services
- **182 resources (15%)** have no extracted content URL (mostly GoFormative links and Eureka Essentials)
- **Output:** `data/embarc/grade-5-sitemap.json` (440 KB)

## Content URL Domains

| Domain | Count | What it is |
|--------|-------|-----------|
| drive.google.com | 711 | PDFs, homework solutions, flipcharts, slides |
| docs.google.com | 217 | Quizzes, lesson plans, pacing guides |
| www.youtube.com | 135 | Lesson videos (1 per lesson, all embeddable) |
| accounts.google.com | 36 | Redirects to Google sign-in (some restricted docs) |
| www.geogebra.org | 21 | Interactive math applets |
| ggbm.at | 2 | GeoGebra short URLs |

## Resource Type Breakdown

| Type | Count | Have URL? | Value for CommonMath |
|------|-------|-----------|---------------------|
| google_slides | 150 | 96% | Medium — presentation format of lesson content |
| lesson_pdf | 150 | 99% | Medium — original lesson PDFs (we already have HTML) |
| promethean_flipchart | 149 | 88% | Low — proprietary IWB format, skip |
| homework_solutions | 148 | 100% | **HIGH** — answer keys for every lesson |
| go_formative | 140 | 0% | Low — platform-dependent, skip |
| exit_ticket_solutions | 135 | 100% | **HIGH** — answer keys for exit tickets |
| video | 135 | 100% | **HIGH** — YouTube embeds, one per lesson |
| smartboard | 36 | 100% | Low — proprietary IWB format, skip |
| parent_newsletter | 34 | 100% | **HIGH** — topic summaries for parents |
| topic_quiz | 32 | 100% | **HIGH** — supplemental assessments |
| geogebra | 19 | 95% | **HIGH** — interactive visualizations |
| application_problems | 13 | 100% | Medium — additional practice problems |
| mid_module_review | 7 | 100% | Medium — review materials |
| fluency_games | 7 | 71% | Medium — supplemental activities |
| end_module_review | 6 | 100% | Medium — review materials |
| downloadable_resources | 6 | 100% | Medium — teacher edition bundles |
| eureka_essentials | 6 | 0% | Medium — pacing/overview docs (external links) |
| number_talks | 2 | 0% | Medium — discussion activities |
| vocabulary | 1 | 100% | Medium — vocabulary card set |
| pacing_guide | 1 | 100% | Medium — lesson pacing guidance |
| online_practice | 1 | 0% | Low — single Moodle quiz |
| other | 16 | 69% | Varies |

## Per-Module Summary

| Module | Topics | Lessons | Resources | With URLs |
|--------|--------|---------|-----------|-----------|
| 0: General Resources | 0 | 0 | 15 | 9 (60%) |
| 1: Place Value & Decimals | 6 | 16 | 143 | 124 (87%) |
| 2: Multi-Digit Operations | 8 | 29 | 236 | 206 (87%) |
| 3: Add/Sub Fractions | 4 | 16 | 137 | 118 (86%) |
| 4: Mult/Div Fractions | 8 | 33 | 268 | 232 (87%) |
| 5: Volume & Area | 4 | 21 | 174 | 150 (86%) |
| 6: Coordinate Plane | 6 | 34 | 221 | 173 (78%) |

**Total: 36 topics, 149 lessons, 1,194 resources**

## What to Import into CommonMath (Priority Order)

### Import Now (high value, clean data)
1. **Videos** (135) — YouTube embed URLs, just store the URL. One per lesson.
2. **Homework Solutions** (148) — Google Drive links to answer key PDFs. Every lesson has one.
3. **Exit Ticket Solutions** (135) — Google Drive links. Every lesson has one.
4. **Topic Quizzes** (32) — Google Docs. Supplemental assessments per topic.
5. **Parent Newsletters** (34) — Google Drive links. Great for B2C/homeschool audience.
6. **GeoGebra Applets** (19) — Interactive embed URLs. High engagement value.

### Import Later (medium value)
7. **Google Slides** (150) — Lesson presentation format. Useful but we already have the content as HTML.
8. **Application Problems** (13) — Additional practice sets.
9. **Mid/End Module Reviews** (13) — Supplemental review materials.
10. **Pacing Guides, Vocabulary, Number Talks** — Grade-level resources.

### Skip (low value for web)
- **Promethean Flipcharts** (149) — Proprietary format for interactive whiteboards
- **SMARTboard files** (36) — Same issue
- **GoFormative Exit Tickets** (140) — Zero content URLs extracted; requires GoFormative platform account
- **Eureka Essentials** (6) — No URLs extracted; may be behind redirects

## Video Strategy

All 135 videos are YouTube embeds with unique video IDs. Sample:
```
https://www.youtube.com/embed/49NPo4y9E9A
https://www.youtube.com/embed/XvUeT3_xNj0
```

**Plan:** Store the YouTube video ID as the `url` field on the SupplementalResource. Render as an embedded iframe in the lesson view. No downloading needed.

## Google Drive Content Strategy

**711 Google Drive links + 217 Google Docs links = 928 total**

Most are "anyone with the link" sharing. Some (36 `accounts.google.com` redirects) may be restricted. For the import:

1. Store the Google Drive/Docs URL as-is in the `url` field
2. For Phase 2 (content embedding): use Google Drive export URLs to fetch HTML/PDF versions
3. Flag any restricted links for manual review

## Data Quality Notes

- Module 6 has slightly lower URL extraction rate (78% vs 86-87% for other modules) — may have more GoFormative or Moodle-native content
- 1 resource had an HTTP redirect error (Module 0, "Extra Resources" — redirects to a Moodle glossary)
- The `accounts.google.com` URLs are likely Google Docs that require sign-in — these may be quiz answer keys or restricted teacher materials
- Some Eureka Essentials pages use external redirects that our scraper couldn't follow

## Next Steps

1. Run `rake embarc:import` to load the sitemap into SupplementalResource records
2. Verify mapping accuracy (spot-check a few lessons)
3. Build lesson view integration (show video, solutions, quiz links)
4. Phase 2: Fetch and inline Google Drive content for homework solutions and exit ticket solutions
