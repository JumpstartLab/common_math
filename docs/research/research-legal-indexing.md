# Legal Research: Reference/Indexing Models and Copyrighted Content

**Research Date:** March 2026
**Context:** Evaluating legal defensibility of scanning physical textbooks to build an internal vector index that surfaces page references to students (e.g., "Box multiplication is on page 56 of your Eureka Math Grade 5 textbook") without reproducing or serving any actual textbook content.

---

## Executive Summary

The proposed use case — scanning textbooks to build an internal index that returns page-level references, not content — sits in a highly favorable legal position compared to the cases that have attracted copyright litigation. The core legal theory parallels Google Books more closely than it parallels AI LLM training cases. The key strength is that the system outputs no copyrighted content whatsoever. However, the act of scanning itself is a reproduction that requires fair use justification, and the first sale doctrine does not cover that act. The analysis below explains why fair use is the right framework, how the four factors apply, and where residual risk lies.

---

## Part 1: The Foundational Cases

### 1.1 Authors Guild v. Google, Inc. (2d Cir. 2015) — The Most Relevant Precedent

**Citation:** 804 F.3d 202 (2d Cir. 2015), cert. denied, 136 S. Ct. 1658 (2016)

This is the single most important case for the proposed use case. The Second Circuit unanimously held that Google's scanning of millions of copyrighted books and creation of a full-text search index was fair use.

**What Google actually did:**
- Scanned tens of millions of books without authorization, creating complete digital copies
- Stored those copies and indexed the full text
- Displayed "snippets" (approximately three lines of text) in response to search queries
- Provided digitized copies back to the libraries that supplied the books

**The court's four-factor analysis:**

*Factor 1 — Purpose and character (transformative use):* The court held Google's use was "highly transformative." Although Google copied the entirety of each work, the copies served a different function: enabling search and discovery rather than reading. The court emphasized that "a transformative use is one that communicates something new and different from the original or expands its utility, thus serving copyright's overall objective of contributing to public knowledge."

*Factor 2 — Nature of the copyrighted work:* The books were published, factual, and informational. This factor was neutral to slightly favorable for Google.

*Factor 3 — Amount used:* Google copied entire books. The court acknowledged this weighed against fair use but held that copying the entirety was "reasonably necessary" to achieve the transformative indexing purpose. You cannot build a complete search index from partial copies.

*Factor 4 — Market effect:* This is the most important factor. The court found Google Books did not harm the market for the original works. In fact, the court noted that the service arguably increased the market for books by enabling discovery. Crucially, the snippets shown were too short and non-contiguous to serve as substitutes for the originals.

**Snippet controls that mattered:** Google implemented "snippet suppression" for certain categories (cookbooks, poetry) and ensured no more than 16% of any book was viewable in aggregate across all queries. These technical safeguards were cited as supporting fair use.

**Relevance to the proposed use case:** The proposed system is more conservative than Google Books in every dimension. Google returned snippets of actual text. The proposed system returns only page references — zero reproduction of the copyrighted text. If Google Books passed the fair use test while showing excerpts, a pure reference system that shows nothing from the text has a substantially stronger position.

---

### 1.2 Authors Guild v. HathiTrust (2d Cir. 2014) — Companion Case

**Citation:** 755 F.3d 87 (2d Cir. 2014)

One year before the Google Books ruling, the Second Circuit upheld fair use for HathiTrust's digital library, which performed full-text searching of scanned books without displaying any text to general users (only metadata and search hit locations). The court found:

- Building a full-text search database from copyrighted works is fair use when no text is displayed
- Access for print-disabled users (text-to-speech) is also fair use
- The preservation copying function was remanded but largely upheld later

**Direct relevance:** HathiTrust is the closer analog. HathiTrust showed users which books contained their search terms and on which pages — essentially metadata and location references, not the text itself. This is structurally almost identical to the proposed system. The Second Circuit explicitly validated this model.

---

### 1.3 Perfect 10, Inc. v. Amazon.com, Inc. (9th Cir. 2007) — Transformative Use in Search Contexts

**Citation:** 508 F.3d 1146 (9th Cir. 2007)

Google's image search generated thumbnail versions of copyrighted photographs. The Ninth Circuit held this was fair use because the thumbnails were "highly transformative" — they converted images from entertainment/artistic objects into pointers directing users to sources of information.

The court framed it: "a search engine transforms the image into a pointer directing a user to a source of information." This framing is highly applicable — an index that converts textbook content into a reference pointer (page 56) does the same thing conceptually.

The court also found market harm could not be presumed given the transformative nature of the use, and that the potential for harm to the market was merely hypothetical.

**Relevance:** Establishes that converting copyrighted works into navigational/reference tools is a recognized category of transformative use, even when the original work is reproduced in creating the tool.

---

### 1.4 Kelly v. Arriba Soft Corp. (9th Cir. 2003) — Precursor to Perfect 10

The Ninth Circuit held that a visual search engine that crawled the internet, downloaded full-resolution copies of images, generated thumbnails, and then deleted the originals was engaged in fair use for the thumbnail display. The downloading and temporary full-resolution storage was considered "intermediate copying" in service of a transformative purpose. This established the principle that temporary or internal copying for indexing purposes does not infringe copyright when the end use is transformative.

---

## Part 2: AI Training Cases — Important but Distinguishable

The current wave of AI copyright litigation is relevant context, but the proposed use case is meaningfully different from LLM training. Understanding the distinctions is important.

### 2.1 Thomson Reuters v. Ross Intelligence (D. Del. 2025)

**Citation:** No. 20-613 (D. Del. Feb. 11, 2025)

A Delaware district court rejected Ross's fair use defense when it used Westlaw's copyrighted headnotes to train an AI legal research tool that would compete directly with Westlaw. Key facts making this case unfavorable to Ross:

- Ross's product was a **direct commercial competitor** to the source material's owner
- Ross had actually **sought a license** and been refused — the court treated this as evidence the use was commercially substitutive
- The trained model was used to answer legal questions in the **same commercial market** as Westlaw

This case is distinguishable because the proposed system: (a) does not compete with textbook publishers — it increases the utility of textbooks students already own; (b) does not reproduce the content in outputs; and (c) would not be seeking access to content that the copyright owner had specifically refused to license for this purpose.

*(Note: The case is on appeal to the Third Circuit as of early 2026.)*

### 2.2 Kadrey v. Meta Platforms, Inc. (N.D. Cal. 2025)

On June 25, 2025, Judge Chhabria found that Meta's use of books (downloaded from shadow libraries) to train Llama LLMs was "highly transformative" and fair use. The court emphasized:

- The purpose of training LLMs (learning patterns, weights) differs fundamentally from the purpose of the original books (being read)
- However, the court warned that a **market dilution** theory — showing LLM outputs flood the market and reduce demand for originals — could have defeated fair use if properly pleaded and proven

**Key distinction for the proposed system:** The proposed system creates no outputs that could substitute for or dilute the market for textbooks. It creates navigational metadata.

### 2.3 Bartz v. Anthropic (N.D. Cal. 2025)

Judge Alsup found that training LLMs on **lawfully acquired** books (that were digitized and the original physical copy destroyed) was "quintessentially transformative" and fair use. He drew a hard line on piracy: copying from unauthorized sources (shadow libraries) did not qualify as fair use even for a transformative purpose.

**Key takeaway for the proposed system:** The provenance of the physical books matters. Buying textbooks on the secondary market (eBay) appears to align with the "lawfully acquired" standard that Anthropic's fair use victory rested on.

### 2.4 U.S. Copyright Office AI Training Report (May 2025)

The Copyright Office released a 108-page report concluding that "some uses of copyrighted works for generative AI training will qualify as fair use, and some will not." The report identified a spectrum:

- **Likely fair use:** Noncommercial research/analysis where the work is not reproduced in outputs
- **Unlikely fair use:** Copying from pirate sources to generate market-competing content when licensing is available

The proposed use case sits closer to the favorable end of this spectrum than any of the LLM training cases: it is an analytical/reference application, outputs contain no copyrighted content, and it does not compete with the textbook market.

### 2.5 The Vector Embeddings Question

There is active legal debate about whether creating vector embeddings of copyrighted text constitutes "copying" under 17 U.S.C. § 106(1). The technical argument for defendants is that embeddings are numerical representations of statistical relationships, not copies of the text. Courts have not yet squarely resolved this question.

However, the intermediate copying doctrine from software cases (Sega v. Accolade, Sony v. Connectix) is instructive: copying that occurs as an intermediate step in a transformative process, where the original content does not appear in the output, has repeatedly been upheld as fair use. If the vector database contains no reproduced text and the system outputs no reproduced text, the strongest argument is that any "copying" that occurs in the embedding process is intermediate copying in service of a transformative reference function.

The enforcement impossibility noted by several legal commentators (that the relationship between embeddings and source text is "mathematically intractable") cuts both ways — it makes infringement claims harder to prove technically, but also means courts may treat the scanning/ingestion stage as the relevant act to analyze.

---

## Part 3: Intermediate Copying Doctrine — Software Reverse Engineering Cases

These cases establish an important principle: copying a copyrighted work as a necessary step to create a non-infringing, transformative product can be fair use even when entire works are copied.

### Sega Enterprises Ltd. v. Accolade, Inc. (9th Cir. 1992)

The Ninth Circuit held that disassembling Sega's copyrighted BIOS code (copying the entire program) was fair use when done to gain access to functional information needed to create compatible games. "Where disassembly is the only way to gain access to the ideas and functional elements embodied in a copyrighted computer program and where there is a legitimate reason for seeking such access, disassembly is a fair use."

**Principle extracted:** Copying an entire work as the necessary means to access functional/structural information for a non-infringing purpose can be fair use.

### Sony Computer Entertainment, Inc. v. Connectix Corp. (9th Cir. 2000)

Connectix copied Sony's PlayStation BIOS entirely to reverse-engineer it, ultimately producing a product that let users play PlayStation games on PCs. The court held this intermediate copying was fair use because the end product was transformative and non-infringing.

**Principle extracted:** Intermediate copying of entire copyrighted works, when necessary to create a different transformative product, is a recognized fair use category. The analysis focuses on the end product, not the copying act in isolation.

**Relevance:** Scanning textbooks to build a reference index is structurally analogous — the copying is intermediate, the end product (a page reference tool) is transformative, and the original content does not appear in the outputs.

---

## Part 4: Andy Warhol Foundation v. Goldsmith — A Cautionary Note on Transformativeness

**Citation:** 598 U.S. 508 (2023)

The Supreme Court's 2023 decision narrowed the transformative use doctrine under Factor 1. The Court held that merely adding artistic expression or new meaning is not sufficient to find transformativeness if the secondary use serves the same commercial purpose as the original. The key question is whether the secondary use serves a "different purpose" from the original.

**Application to the proposed system:** This case argues for being precise in characterizing the "different purpose." The proposed system's purpose is not to provide educational content (which is what the textbook does) — it is to provide navigation and discovery within content the user already possesses. A student cannot use the app to learn box multiplication; they must go to the textbook. The app's purpose is reference/indexing, which is categorically different from the textbook's purpose of instruction. This distinction should survive the Goldsmith analysis.

---

## Part 5: Four-Factor Fair Use Analysis Applied to the Proposed System

### Factor 1: Purpose and Character of the Use

**Analysis:** This factor weighs strongly in favor of fair use.

The use is transformative: it converts instructional text into a navigational/reference tool. The textbook's purpose is to teach content. The index's purpose is to locate where content is explained. These are categorically different functions.

The commercial nature of the app is a negative consideration under Goldsmith's narrowed transformativeness test. However, commercial purpose alone does not defeat fair use (Campbell v. Acuff-Rose, 510 U.S. 569 (1994)). The question is whether the commercial purpose is the same as the original's commercial purpose. A textbook sells instruction; a reference tool sells discovery and navigation. These are distinct markets.

The educational context of the app's users (K-12 students) and the fact that it facilitates use of legitimately purchased textbooks strengthen the case further.

### Factor 2: Nature of the Copyrighted Work

**Analysis:** This factor is moderately favorable.

Textbooks are primarily factual and instructional rather than creative/expressive. Copyright protection is thinner for factual works than for fiction or art. Math instructional content — particularly curriculum like Eureka Math — is highly factual: procedures, techniques, worked examples. The more factual the work, the more room there is for fair use.

Courts have consistently held that factual and informational works receive less copyright protection than creative works. This factor leans in favor of fair use.

### Factor 3: Amount and Substantiality of the Portion Used

**Analysis:** This factor weighs against fair use — but less than it might appear.

Entire textbooks would be scanned. Courts universally note that copying entire works weighs against fair use. However, both Google Books and HathiTrust involved copying entire works and still found fair use because copying the entirety was "reasonably necessary" to the transformative purpose. You cannot build a complete page-reference index without scanning the complete book.

The critical limiting principle from both cases: how much of the work is actually surfaced to users. Google Books showed snippets (16% aggregate). HathiTrust showed nothing. The proposed system shows nothing — only metadata (page numbers). On this dimension, the use is actually more favorable than both precedents.

The argument: copying the whole is necessary for the purpose, but the purpose is served by extracting only structural metadata (what concepts appear on which pages), not by reproducing the text. This is the strongest available argument on Factor 3.

### Factor 4: Effect on the Potential Market for the Work

**Analysis:** This is the most important factor, and it strongly favors fair use.

The proposed system does not substitute for or compete with the textbook. A student cannot use the app to learn math without the textbook — the app explicitly directs them back to the textbook. If anything, the app increases the value and utility of the textbook by making it easier to navigate and use. It is a complement, not a substitute.

No market substitution exists because:
1. The app does not reproduce any content the student would otherwise need to buy
2. The app is only useful to students who already own the textbook
3. If the app works well, students will use their textbooks more, not less

The Google Books court noted that Google's service likely helped book sales by improving discoverability. The proposed system has an even stronger complementary relationship with the original works.

One area of potential risk: the **licensing market**. If textbook publishers begin licensing their content for indexing/reference apps (and collecting fees for that), a court could find that the proposed system harms this nascent licensing market. Thomson Reuters v. Ross turned in part on the court's willingness to consider harm to a "potential" licensing market. This is the most realistic legal risk, and it should be monitored.

---

## Part 6: First Sale Doctrine — Applicability and Limits

### What First Sale Covers

The first sale doctrine (17 U.S.C. § 109) allows the owner of a lawfully made copy to sell, lend, or give away that physical copy without the copyright holder's permission. This is what allows used bookstores, libraries, and eBay sales of textbooks to operate legally.

### What First Sale Does Not Cover

First sale applies to the **distribution right**, not the **reproduction right**. Scanning a book creates a new digital copy — that is an exercise of the reproduction right, which is not exhausted by first sale.

**Capitol Records v. ReDigi (2d Cir. 2018):** The Second Circuit definitively held that creating a digital copy during a transfer constitutes reproduction, which first sale does not permit. ReDigi's service transferred digital music files but created a new digital copy in the process — that was infringement.

**Key conclusion:** Buying textbooks on eBay is entirely legal under first sale and establishes clear provenance of lawfully acquired copies. However, the first sale doctrine does not provide legal cover for the scanning itself. The scanning must be justified by fair use (or a license).

This is not a fatal problem — it simply means the legal analysis runs entirely through fair use, not first sale. The Bartz v. Anthropic ruling (fair use for AI training on "lawfully acquired" books) supports the view that eBay-purchased textbooks qualify as a lawful acquisition that supports fair use analysis.

### Secondary Market Purchases and Fair Use

The Bartz ruling drew a sharp line between lawfully acquired copies and pirated copies. Buying physical textbooks through legitimate channels (eBay, used bookstores, retail) and scanning them appears to be on the right side of that line. The copying occurs as part of a transformative indexing use on lawfully purchased copies, which is structurally similar to what Anthropic did with the physical books that Judge Alsup found to be fair use.

---

## Part 7: Google Scholar — Approach and Precedent

Google Scholar indexes academic papers, legal decisions, and books. It shows metadata (title, authors, journal, year), citation counts, and in many cases brief excerpts or abstracts. For books, it shows limited snippets.

Google Scholar has largely operated without major litigation, for several reasons:
1. Much academic content is published with open access provisions or under licenses that permit indexing
2. For paywalled content, Scholar shows only metadata or very short excerpts
3. Its purpose is discovery/reference, not content delivery

**No landmark Google Scholar-specific rulings exist** on the question of indexing. It has benefited from the legal cover established by the Google Books/HathiTrust litigation and operates within those limits. The practical takeaway is that Google has run large-scale indexing operations for over two decades with the same theory the proposed system would rely on — and the most serious legal challenges to that theory (Authors Guild cases) were ultimately resolved in Google's favor.

---

## Part 8: Cases Involving Educational Content Specifically

### Cambridge University Press v. Patton (Georgia State University) (11th Cir. 2014, 2016, 2020)

Georgia State University made digital excerpts of copyrighted academic books available through its electronic reserve system. Publishers sued. The litigation ran for over a decade with rulings in multiple rounds.

**Key outcomes:**
- The Eleventh Circuit ultimately found that most of GSU's copying was not fair use when it involved substantial portions (multiple chapters) of works that had licensed digital alternatives available
- Short excerpts (a single chapter from a longer work) were more defensible
- The court emphasized that when a licensed digital market exists, fair use is harder to claim

**Distinction from the proposed system:** GSU was reproducing and distributing content to students. The proposed system does not reproduce or distribute any content. This is a categorical difference. The GSU cases involved exactly what the proposed system avoids: giving students access to the text itself.

### American Geophysical Union v. Texaco (2d Cir. 1994)

Texaco scientists copied individual journal articles for personal research use. The Second Circuit found infringement, emphasizing that a legitimate licensing market (the Copyright Clearance Center) existed for exactly this kind of copying.

**Distinction:** Again, Texaco was reproducing and using content. The proposed system does not reproduce content in its outputs.

---

## Part 9: Key Risk Factors and Mitigations

### Risk 1: The Scanning Act Itself (Medium Risk)

The act of digitizing textbooks is a reproduction under 17 U.S.C. § 106(1). Fair use is the necessary defense. The analysis above supports a strong fair use argument, but it has not been tested in court for this exact use case.

**Mitigation:** The Google Books/HathiTrust precedents are directly on point. The transformative purpose (navigation vs. instruction) and the absence of any reproduced content in outputs are the strongest facts available. Using only lawfully purchased physical copies (documented purchase records) strengthens the provenance argument.

### Risk 2: The Licensing Market Argument (Medium Risk)

Publishers could argue that they are developing (or could develop) licensing programs for educational indexing/AI applications, and the proposed system undermines that potential market. Thomson Reuters v. Ross (currently on appeal) showed courts are sometimes willing to consider harm to nascent licensing markets.

**Mitigation:** The market harm argument is weakest when the use is genuinely complementary rather than substitutive. If the app can demonstrate that textbook usage increases with the tool (engagement data, teacher feedback), that is direct evidence against market harm. Proactively approaching publishers about licensing is both a risk mitigation strategy and a potential business opportunity — if publishers license at reasonable rates, the legal risk disappears entirely.

### Risk 3: Vector Embedding as Reproduction (Low-Medium Risk)

Some copyright scholars argue that creating embeddings of text is itself a reproduction in a form courts have not yet fully analyzed. No court has squarely held that embedding-only operations (where no text is reproduced in outputs) infringe copyright.

**Mitigation:** The intermediate copying doctrine, Google Books precedent, and HathiTrust all point toward this being covered by fair use. The Copyright Office's May 2025 report identified the absence of reproduction in outputs as a favorable factor. This risk is low but unresolved.

### Risk 4: Publisher Curriculum Ownership (Low Risk)

Some math curricula (Eureka Math, Illustrative Mathematics) are open educational resources or published under licenses that may permit indexing explicitly. Others (Saxon, Everyday Math) are commercially published. Checking the license terms of each curriculum before indexing could eliminate legal risk for open-licensed materials entirely.

**Mitigation:** Start with open educational resource curricula (Eureka Math / EngageNY is licensed under Creative Commons Attribution-NonCommercial-ShareAlike). This approach would be legally clean and provide a proven product before tackling commercially published content.

---

## Part 10: Comparative Summary — How the Proposed System Compares to Precedents

| Factor | Google Books | HathiTrust | AI LLM Training | Proposed System |
|---|---|---|---|---|
| Complete works scanned? | Yes | Yes | Yes | Yes |
| Output includes reproduced text? | Snippets (limited) | No | Often yes | **No** |
| Transformative purpose? | Yes — search/discovery | Yes — search/disability | Yes — pattern learning | **Yes — navigation/reference** |
| Competing with original market? | No | No | Sometimes | **No — complementary** |
| Lawfully acquired copies? | Via libraries | Via libraries | Mixed | **Yes — purchased copies** |
| Fair use found? | Yes (2d Cir. 2015) | Yes (2d Cir. 2014) | Mixed (2025) | *Untested but favorable* |

The proposed system is more conservative than every precedent where fair use was found. It reproduces less than Google Books, which was upheld. It is structurally almost identical to HathiTrust's full-text search functionality, which was also upheld.

---

## Part 11: Legal Strategy Recommendations

1. **Establish clear provenance.** Buy all textbooks through traceable channels (eBay with transaction records, retail receipts). Document each purchase. Destroy or archive the physical copy after scanning, mirroring the Anthropic approach that Judge Alsup found favorable.

2. **Implement no-reproduction architecture.** Ensure the system design makes it technically impossible to retrieve actual textbook text. The vector database should be structured so that queries return page references and concept tags, not text passages. This is both a legal protection and a product design choice.

3. **Start with open-licensed curricula.** Eureka Math (EngageNY) is licensed under Creative Commons CC BY-NC-SA 4.0, which permits non-commercial reuse with attribution. Beginning with this curriculum eliminates copyright risk entirely for that content and establishes the product's viability before engaging with commercially published materials.

4. **Consider a publisher licensing approach.** Proactively seeking non-exclusive indexing licenses from publishers transforms the legal posture entirely and may be welcomed by publishers who see it as increasing textbook value. Even one license agreement provides a model that demonstrates the use case is legitimate and distinguishes the company from bad actors.

5. **Monitor the Thomson Reuters v. Ross appeal.** The Third Circuit's ruling on what constitutes a "potential market" for copyright purposes will have significant implications. If the Third Circuit narrows the potential market analysis, it strengthens the proposed system's position on Factor 4.

6. **Keep the AI/generative component clearly separated in architecture and communications.** The legal risk in current AI copyright cases centers on generative outputs that reproduce or compete with original works. The proposed system is a retrieval-and-reference tool, not a generative one. Being explicit about this distinction in product documentation, terms of service, and legal filings matters.

---

## Part 12: Overall Legal Assessment

**Defensibility: Strong, but not risk-free.**

The proposed use case — scanning to build an internal index that returns page references only — is more legally conservative than any precedent where fair use was found. It is less aggressive than Google Books (which returned snippets of text), and structurally very close to HathiTrust (which returned only search hits and page locations). Both were upheld as fair use by the Second Circuit.

The primary legal exposure is:
1. The scanning/reproduction act itself requires fair use justification (not covered by first sale)
2. The potential for publishers to argue a nascent licensing market is being harmed
3. Residual uncertainty about whether vector embeddings constitute reproduction under copyright law

None of these risks are fatal, and the mitigations above address each one. The greatest practical risk may be the threat of litigation itself — even meritless or uncertain claims from major textbook publishers are expensive to defend. A licensing strategy that converts potential adversaries into partners is worth serious consideration alongside the fair use defense.

The proposed system has the factual profile that copyright law's fair use doctrine was designed to protect: a transformative use that serves the public by making existing works more useful, with no reproduction of content, no market substitution, and lawfully acquired source material.

---

## Sources

- [Authors Guild v. Google, Inc., 804 F.3d 202 (2d Cir. 2015) — Justia](https://law.justia.com/cases/federal/appellate-courts/ca2/13-4829/13-4829-2015-10-16.html)
- [Authors Guild v. Google — Wikipedia](https://en.wikipedia.org/wiki/Authors_Guild,_Inc._v._Google,_Inc.)
- [Authors Guild v. Google — Copyright.gov Fair Use Summary](https://www.copyright.gov/fair-use/summaries/authorsguild-google-2dcir2015.pdf)
- [Second Circuit Affirms Fair Use in Google Books — Association of Research Libraries](https://www.arl.org/blog/second-circuit-affirms-fair-use-in-google-books-case/)
- [Authors Guild v. Google — Stanford Copyright & Fair Use Center](https://fairuse.stanford.edu/case/authors-guild-v-google-inc/)
- [Authors Guild v. Google — Full Opinion (Berkeley Law)](https://www.law.berkeley.edu/wp-content/uploads/2016/05/Authors-Guild-v-Google-804_F.3d_202.pdf)
- [Authors Guild v. HathiTrust, 755 F.3d 87 (2d Cir. 2014) — Copyright.gov](https://www.copyright.gov/fair-use/summaries/authorsguild-hathitrust-2dcir2014.pdf)
- [Authors Guild v. HathiTrust — Wikipedia](https://en.wikipedia.org/wiki/Authors_Guild,_Inc._v._HathiTrust)
- [Perfect 10, Inc. v. Amazon.com, Inc., 508 F.3d 1146 (9th Cir. 2007) — Copyright.gov](https://www.copyright.gov/fair-use/summaries/perfect10-amazon-9thcir2007.pdf)
- [Perfect 10 v. Amazon — Wikipedia](https://en.wikipedia.org/wiki/Perfect_10,_Inc._v._Amazon.com,_Inc.)
- [Perfect 10 v. Google — EFF](https://www.eff.org/cases/perfect-10-v-google)
- [Andy Warhol Foundation v. Goldsmith — Wikipedia](https://en.wikipedia.org/wiki/Andy_Warhol_Foundation_for_the_Visual_Arts,_Inc._v._Goldsmith)
- [Andy Warhol Foundation v. Goldsmith — Copyright.gov Summary](https://www.copyright.gov/fair-use/summaries/Andy-Warhol-Found-for-the-Visual-Arts-Inc-v-Goldsmith-143-S-Ct-1258-2023.pdf)
- [Thomson Reuters v. Ross Intelligence — Reed Smith Analysis](https://www.reedsmith.com/en/perspectives/2025/03/court-ai-fair-use-thomson-reuters-enterprise-gmbh-ross-intelligence)
- [Thomson Reuters v. Ross — Davis Wright Tremaine](https://www.dwt.com/blogs/artificial-intelligence-law-advisor/2025/02/reuters-ross-court-ruling-ai-copyright-fair-use)
- [Thomson Reuters v. Ross — Loeb & Loeb](https://www.loeb.com/en/insights/publications/2025/02/thomson-reuters-v-ross-intelligence-inc)
- [Kadrey v. Meta: AI Training Found to Be Fair Use](https://daveadr.com/blog/fairuseandaitraining)
- [Kadrey v. Meta — Goodwin Law](https://www.goodwinlaw.com/en/insights/publications/2025/06/alerts-practices-aiml-northern-district-of-california-judge-rules)
- [Bartz v. Anthropic — Wiggin and Dana](https://www.wiggin.com/publication/bartz-v-anthropic-first-court-decision-on-fair-use-defense-in-llm-training/)
- [Bartz v. Anthropic Settlement — Inside Tech Law](https://www.insidetechlaw.com/blog/2025/09/bartz-v-anthropic-settlement-reached-after-landmark-summary-judgment-and-class-certification/)
- [Copyright and AI Collide: Three Key Decisions 2025 — IPWatchdog](https://ipwatchdog.com/2025/12/23/copyright-ai-collide-three-key-decisions-ai-training-copyrighted-content-2025/)
- [Copyright Office AI Training Report May 2025 — Skadden](https://www.skadden.com/insights/publications/2025/05/copyright-office-report)
- [Copyright Office AI Report Part 3 — Full Pre-Publication PDF](https://www.copyright.gov/ai/Copyright-and-Artificial-Intelligence-Part-3-Generative-AI-Training-Report-Pre-Publication-Version.pdf)
- [Mid-Year Review: AI Copyright Case Developments 2025 — Copyright Alliance](https://copyrightalliance.org/ai-copyright-case-developments-2025/)
- [First Sale Doctrine — Wikipedia](https://en.wikipedia.org/wiki/First-sale_doctrine)
- [First Sale Doctrine and Digital Goods (Kirtsaeng and ReDigi) — OSU Copyright Corner](https://library.osu.edu/site/copyright/2013/04/23/the-first-sale-doctrine-and-the-sale-of-digital-goods-in-light-of-kirtsaeng-and-redigi-inc/)
- [Sega v. Accolade — Wikipedia](https://en.wikipedia.org/wiki/Sega_v._Accolade)
- [Sony v. Connectix, 203 F.3d 596 (9th Cir. 2000) — Justia](https://law.justia.com/cases/federal/appellate-courts/F3/203/596/474793/)
- [Intermediate Copying and Fair Use — Thompson Coburn](https://www.thompsoncoburn.com/insights/intermediate-copying-and-fair-use-two-approaches-from-the-same-bench/)
- [What are embeddings with respect to copyright law? — OpenAI Community](https://community.openai.com/t/what-are-embeddings-with-respect-to-copyright-law/589971)
- [Fair Use and AI Training: Two Recent Decisions — Skadden](https://www.skadden.com/insights/publications/2025/07/fair-use-and-ai-training)
- [Google Scholar Publishers Page](https://scholar.google.com/intl/en/scholar/publishers.html)
