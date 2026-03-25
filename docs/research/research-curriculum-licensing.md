# Math Curriculum Licensing Research

**Research date:** March 2026
**Purpose:** Evaluate licensing terms for major openly-available math curriculum sources to determine what can be used in a commercial product.

---

## Executive Summary

The short answer for a commercial product developer: most prominently "open" math curricula are licensed **CC BY-NC-SA**, which prohibits commercial use. The exceptions are Illustrative Mathematics (CC BY 4.0 for its core curriculum) and OpenStax Prealgebra/other select titles (CC BY 4.0). These two are the most commercially viable sources. EngageNY/Eureka Math, Khan Academy exercises, and CK-12 all restrict commercial use under their respective licenses.

---

## 1. EngageNY: License Terms

### Background

EngageNY is the name under which the New York State Education Department (NYSED) published K–12 curriculum materials starting around 2012. The mathematics curriculum was written by the nonprofit Great Minds under contract with NYSED. The materials were released as an open educational resource (OER) and have been downloaded over 13 million times.

### License

All EngageNY ELA and mathematics materials are licensed under:

**Creative Commons Attribution-NonCommercial-ShareAlike (CC BY-NC-SA) 3.0 Unported**

The NYSED website references `creativecommons.org/licenses/by-nc-sa/3.0/` as the governing license, confirming this is the 3.0 (Unported) version, not the newer 4.0 International.

### What CC BY-NC-SA 3.0 Requires

- **Attribution (BY):** You must give credit to the original author/source (NYSED/Great Minds), provide a link to the license, and indicate if changes were made.
- **NonCommercial (NC):** You may not use the material for commercial purposes. The legal code defines this as uses "not primarily intended for or directed towards commercial advantage or monetary compensation."
- **ShareAlike (SA):** If you remix, transform, or build upon the materials, you must release your derivative work under the exact same CC BY-NC-SA license.

### Practical Implications

- Free use by schools, nonprofits, and individual educators: permitted.
- Modification and redistribution for noncommercial purposes: permitted with attribution and ShareAlike compliance.
- Use in a commercial product (paid app, SaaS platform, paid service): **prohibited** without a separate license from the rights holder.
- The ShareAlike clause also creates a "viral" effect: any derivative work must also be CC BY-NC-SA, making it incompatible with commercial licensing.

### Where EngageNY Lives Now

NYSED retired the engageny.org domain in March 2022. The materials are now hosted at `nysed.gov/curriculum-instruction/engageny` and the license terms remain unchanged.

---

## 2. Eureka Math (Great Minds): License Terms and the EngageNY Distinction

### The Relationship Between EngageNY Math and Eureka Math

Great Minds wrote the EngageNY mathematics curriculum under contract with NYSED. After that contract concluded, Great Minds continued developing and commercially branding the same curriculum as **Eureka Math**. Great Minds itself describes EngageNY Math as the precursor to Eureka Math, and their website confirms they are effectively the same curriculum at the core.

### Licensing: Two Tracks

This is where the distinction matters:

#### Track 1: The Original OER (EngageNY / Free Eureka Math Downloads)

The original curriculum, still downloadable for free from both NYSED and greatminds.org, is licensed under **CC BY-NC-SA 4.0 International** (Great Minds upgraded the license from 3.0 to 4.0 on their own copies, while NYSED's original posting retained the 3.0 reference). The ASSISTments platform, which hosts EngageNY/Eureka Math problems, confirms the content is under **CC BY-NC-SA 3.0 Unported** for the NYSED-origin materials.

**Key point:** The OER version is free to download but restricted to noncommercial use with ShareAlike obligations.

#### Track 2: Commercial Eureka Math Products

Great Minds sells printed workbooks, digital platform subscriptions (Eureka Digital Suite), professional development services, and the newer **Eureka Math²** (Eureka Math Squared) curriculum. These are fully commercial products requiring purchase and are governed by separate commercial license agreements.

Eureka Math² in particular does not appear to be available as an OER — it is a premium commercial curriculum with no freely downloadable OER version.

### The "Right to Collect Royalties" Provision

Great Minds' copyright notice for the CC-licensed version explicitly states that the CC BY-NC-SA license reserves their right to collect royalties from entities that use the materials for commercial purposes. This is consistent with the CC license structure: the open license covers noncommercial use; commercial use requires a separate negotiated agreement.

---

## 3. Commercial Use of EngageNY/Eureka Math: What Is and Is Not Permitted

### What Is Clearly Prohibited

- Building a paid educational app that incorporates Eureka Math problems or problem sequences.
- A for-profit platform that charges schools or families to access adapted Eureka Math content.
- Any derivative product distributed commercially, regardless of whether the curriculum content is the primary source of value.
- Incorporating these materials into a product sold or licensed for a fee.

### What Is Permitted (Under the OER License)

- A nonprofit or individual educator creating and freely distributing their own modified curriculum under the same CC BY-NC-SA terms.
- A free-to-use (no monetization) educational website that attributes Great Minds and NYSED.
- Schools printing or distributing the materials for classroom use (noncommercial by definition).

### The Third-Party Contractor Question (Clarified by Courts)

A nuanced point: school districts that legitimately hold the noncommercial license can hire for-profit vendors to help them implement that license (e.g., printing copies). This was the holding of two federal court cases (discussed in Section 4). However, this does not extend to a commercial product developer — the school district's license cannot be sublicensed to a third-party commercial developer.

---

## 4. Legal Cases and Disputes

### Great Minds v. FedEx Office (2016–2018)

**Court:** Eastern District of New York; affirmed by the Second Circuit Court of Appeals (March 21, 2018).

**Facts:** Great Minds sued FedEx for copyright infringement after school districts hired FedEx to print copies of Eureka Math materials. Great Minds argued that FedEx, as a for-profit company making money on the printing service, was using the materials "commercially," violating the NC clause.

**Ruling:** The court dismissed Great Minds' complaint. The key holding: the CC BY-NC-SA license permits the *licensee* (the school district) to have a third-party vendor assist in exercising their own licensed rights, even if that vendor profits from the service. The "noncommercial" restriction attaches to the *use* (educational, noncommercial), not to every business transaction in the delivery chain.

**Significance:** This established that CC BY-NC-SA does not require every party in the chain to be a nonprofit. It also exposed how ambiguous the "noncommercial" language in CC licenses can be — Creative Commons itself commissioned a 255-page study acknowledging substantial uncertainty in the definition.

### Great Minds v. Office Depot (2018–2019)

**Court:** Central District of California; affirmed by the Ninth Circuit Court of Appeals (December 27, 2019) — *Great Minds v. Office Depot, Inc.*, 945 F.3d 1106 (9th Cir. 2019).

**Facts:** Same theory as the FedEx case: Great Minds sued Office Depot after school districts used Office Depot's copy services to reproduce Eureka Math materials. Great Minds again argued Office Depot was making commercial use of the licensed materials.

**Ruling:** The Ninth Circuit unanimously affirmed dismissal. The court held that Office Depot was not a "licensee" under the CC license and therefore was not bound by its noncommercial restriction. The school districts were the licensees; they were using the materials for noncommercial educational purposes. Office Depot was acting as a service provider to the districts, not independently reproducing the materials for commercial gain.

**Key Quote:** The panel noted that "school districts could have assigned employees to make the copies instead of outsourcing the task to Office Depot, and it would make no sense for the legal outcome to differ based on that operational choice."

**Significance:** Both the FedEx and Office Depot rulings are important because they establish that the noncommercial clause does not prevent schools from outsourcing operational tasks to commercial vendors. However, they explicitly do not address — and do not authorize — a commercial developer independently creating and selling a product based on CC-licensed curriculum materials. The facts are categorically different: a commercial app developer is not acting as a service provider to a noncommercial licensee.

### Attribution Dispute (Illustrative Mathematics / Open Up Resources)

A separate non-litigation dispute arose in the OER community when Illustrative Mathematics alleged that Open Up Resources (which had been a distribution partner) was not properly attributing the IM curriculum after their relationship changed. This was resolved contractually rather than in court, but it highlights that attribution requirements under CC licenses are taken seriously by curriculum developers even in the OER ecosystem.

---

## 5. Other Openly Licensed Math Curriculum Resources

### Illustrative Mathematics (IM)

**License:** CC BY 4.0 International (Attribution only, no NonCommercial restriction)

**What this means for commercial use:**
- The CC BY 4.0 license permits remixing, transforming, and building upon the material **for any purpose, including commercial**, as long as attribution is given.
- Attribution must be given to Illustrative Mathematics; you cannot imply IM endorses your product.
- IM's name and logo are **not** covered by the CC license and require separate written permission to use.

**Practical implications for a commercial product:**
This is the most commercially friendly of the major open curriculum sources. A commercial product developer could legally incorporate IM curriculum content with proper attribution. However, IM also notes that commercial providers may wish to contact them about formal commercial licensing (especially if you want an "IM Certified" designation). The CC BY 4.0 license does not require this — it is a voluntary certification relationship.

**Important caveat:** Some IM materials distributed through third parties (e.g., the Open Up Resources 6–8 Math hosted on openupresources.org) carry a **CC BY-NC 4.0** license rather than CC BY 4.0. The license depends on which distribution channel you access. The official IM curriculum repository is the safest source for the fully permissive CC BY 4.0 version.

**Trademark restriction:** The IM name and logo are registered trademarks and cannot be used to suggest endorsement. A commercial product must make clear it is not affiliated with or endorsed by Illustrative Mathematics.

### OpenStax

**License:** Varies by title — some are CC BY 4.0, others are CC BY-NC-SA 4.0.

**Math-specific breakdown:**
- *Prealgebra 2e*: CC BY 4.0 — commercial use permitted with attribution.
- *Elementary Algebra 2e*: CC BY 4.0 — commercial use permitted.
- *Intermediate Algebra 2e*: CC BY 4.0 — commercial use permitted.
- *Contemporary Mathematics*: CC BY 4.0 — commercial use permitted.
- *Algebra 1* (the K–12-targeted title): CC BY-NC-SA 4.0 — **commercial use prohibited**.

**Attribution requirement:** "Download for free at OpenStax.org" or equivalent must appear on every page that uses OpenStax content.

**Key point:** OpenStax college-level math titles are generally CC BY, making them usable in commercial products with attribution. The K–12-targeted *Algebra 1* title is an exception and carries the more restrictive NC-SA terms.

### Khan Academy

**License:** CC BY-NC-SA

**What this means:** Khan Academy's video and exercise content is licensed CC BY-NC-SA. The NC restriction is broadly defined:
- Incorporating Khan Academy content into a paid platform is not "noncommercial."
- Displaying ads on a site using Khan Academy content is considered commercial.
- Using Khan Academy content to build a product that costs more because of that content (e.g., charging a premium for a tutoring service that includes KA materials) violates the NC clause.

**API status:** Khan Academy deprecated the public content API that allowed pulling exercise content. As of 2020, the `/topictree` and other content API endpoints are no longer available for third-party use. This is a practical barrier independent of the licensing question.

**Attribution requirement:** Must credit Khan Academy and include a link to khanacademy.org with the verbiage "Note: All Khan Academy content is available for free at www.khanacademy.org."

**Bottom line:** Khan Academy content is not usable in a commercial product both for legal reasons (CC BY-NC-SA) and practical reasons (no content API).

### CK-12

**License:** Custom "Curriculum Materials License" — not a standard Creative Commons license.

**What this means:**
- CK-12 uses a proprietary license that restricts use to defined "Educational Purposes."
- Commercial use is explicitly prohibited.
- There is a specific prohibition on using CK-12 materials to **build or train AI/machine learning models**, which is unusual and notable.
- An explicit prohibition on using materials as part of "for-profit educational institutions" or "aggregator" services.
- Derivative works must be released under the same CK-12 license.

**Bottom line:** More restrictive than even CC BY-NC-SA in some respects. Not usable in a commercial product. The AI training prohibition makes this especially relevant to note for any product with generative or adaptive features.

### Open Up Resources (OUR)

**License:** CC BY-NC 4.0 for most curricula (including the 6–8 Math based on Illustrative Mathematics content); CC BY 4.0 for the Odell ELA digital program only.

**What this means:** The OUR 6–8 Math curriculum (sometimes encountered as "Illustrative Mathematics 6–8 via Open Up Resources") prohibits commercial use. This is a more restrictive license than what IM offers directly. Assessments (Pre-Unit, Mid-Unit, End-of-Unit tests) and 5 Practices Charts are additionally restricted and require written permission.

**Takeaway:** If you encounter IM curriculum materials hosted through Open Up Resources, the license is more restrictive. Go to the source (illustrativemathematics.org) for the CC BY 4.0 version.

### Desmos Curriculum (Now: Amplify Desmos Math)

Desmos was acquired by Amplify in 2022. The curriculum is now a commercial product sold as "Amplify Desmos Math" for grades K–12. It is not available under an open license. Individual free activities remain available on Desmos Classroom (the calculator/activity platform), but the coherent curriculum is proprietary.

The Desmos graphing/scientific calculators themselves (Desmos Studio, now a separate PBC) remain free to use and are available for product integration under a commercial license from Desmos Studio.

### Carnegie Math Pathways

**License:** CC BY-NC 4.0

Quantway and Statway developmental math course materials became available as OER in 2024 under CC BY-NC 4.0. These are college-level developmental math pathways (not K–12). Commercial use is prohibited.

---

## 6. Copyright Principles for Math Problems Specifically

Beyond the licensing question, there is a separate legal question about whether specific math problems are copyrightable at all. This matters because the restriction in CC licenses only applies to copyrightable expression.

### General Rule: Mathematical Facts Are Not Copyrightable

Numbers, equations, and mathematical facts are not protectable by copyright. The expression of a mathematical idea — the specific wording, diagram, or presentation — can be copyrighted, but not the underlying problem type or mathematical concept.

Practical implications:

- A problem like "3 + 4 = ?" contains no original expression and cannot be copyrighted.
- A word problem with creative contextual framing ("Maria has 3 apples and gives 1 to her friend...") has some copyrightable expression in its specific wording.
- Changing the parameters (numbers, names, contexts) of a word problem while retaining the pedagogical structure generally avoids copyright infringement, because the *idea* of the problem type is not protected — only the specific expression.
- A **curriculum sequence** or pedagogical structure (e.g., the order in which concepts are taught) is not copyrightable as an idea, though the specific textual and visual expression of that curriculum is.

### Compilation Copyright

The *selection and arrangement* of problems in a curriculum can receive copyright protection as a compilation, even if individual problems are not independently copyrightable. This means copying substantial portions of a curriculum's problem sets — even if each individual problem might be unprotectable on its own — could infringe the compilation copyright.

### Practical Guidance

Creating original problems *inspired by* the problem types and pedagogical approaches in EngageNY/Eureka Math, using different numbers, names, contexts, and wording, is generally safe from a copyright perspective. Reproducing the exact text, diagrams, or sequence structure verbatim would not be.

---

## 7. Summary Comparison Table

| Curriculum | License | Commercial Use Allowed? | Attribution Required? | ShareAlike Required? | Notes |
|---|---|---|---|---|---|
| EngageNY Math | CC BY-NC-SA 3.0 | No | Yes | Yes | NYSED-hosted; noncommercial only |
| Eureka Math (original OER) | CC BY-NC-SA 4.0 | No | Yes | Yes | Great Minds-hosted version; same restriction |
| Eureka Math² | Proprietary/Commercial | Requires purchase | N/A | N/A | No OER version available |
| Illustrative Mathematics (direct) | CC BY 4.0 | Yes | Yes | No | Most commercially permissive K–12 source |
| IM via Open Up Resources | CC BY-NC 4.0 | No | Yes | No | More restrictive than direct IM |
| OpenStax (most college math) | CC BY 4.0 | Yes | Yes | No | Prealgebra 2e, Elementary/Intermediate Algebra 2e |
| OpenStax Algebra 1 (K–12) | CC BY-NC-SA 4.0 | No | Yes | Yes | K–12 title is more restrictive |
| Khan Academy | CC BY-NC-SA | No | Yes | Yes | Also: public content API deprecated |
| CK-12 | Custom license | No | Yes | Yes | Explicit AI/ML training prohibition |
| Desmos Curriculum | Proprietary (Amplify) | Requires purchase | N/A | N/A | No OER version |
| Carnegie Math Pathways | CC BY-NC 4.0 | No | Yes | No | College developmental math only |

---

## 8. Recommendations for a Commercial Product

### Best Sources for Commercial Use

1. **Illustrative Mathematics (direct from illustrativemathematics.org):** The CC BY 4.0 license is the most commercially permissive. You can build on this content in a commercial product with attribution. Trademark guidelines apply (cannot use the IM name/logo to imply endorsement).

2. **OpenStax college-level math titles (not Algebra 1):** Prealgebra 2e, Elementary Algebra 2e, Intermediate Algebra 2e, and Contemporary Mathematics are all CC BY 4.0. Well-suited for high school and college-level content.

### Approach for EngageNY/Eureka Math Content

If the goal is to implement pedagogical approaches *inspired by* Eureka Math or EngageNY — without reproducing the specific text, diagrams, or sequences verbatim — that is generally outside the scope of copyright protection (you cannot copyright a teaching philosophy or problem type). Original problems created in the style of the curriculum do not infringe copyright.

If the goal is to directly use or adapt substantial portions of the actual text and materials in a commercial product, a separate commercial license from Great Minds would be required. Great Minds does not publicly advertise such a licensing program but can be contacted directly.

### Red Lines to Avoid

- Do not copy problem text, diagrams, or instructional sequences verbatim from CC BY-NC-SA sources for commercial use.
- Do not use the Eureka Math, EngageNY, Khan Academy, or CK-12 names or logos to suggest endorsement.
- Do not build a training dataset for AI/ML from CK-12 materials.
- Do not rely on the FedEx/Office Depot rulings as cover for commercial product development — those cases involved vendors acting as service providers to licensed school districts, a categorically different situation.

---

## Sources Consulted

- NYSED EngageNY page: https://www.nysed.gov/curriculum-instruction/engageny
- Great Minds FAQ: https://greatminds.org/faq
- Great Minds Copyright Notice (via ASSISTments): https://www.assistments.org/copyright-notice/great-minds-copyright-notice
- Great Minds Terms of Service: https://greatminds.org/legal/terms-of-service
- *Great Minds v. Office Depot, Inc.*, 945 F.3d 1106 (9th Cir. 2019): https://law.justia.com/cases/federal/appellate-courts/ca9/18-55331/18-55331-2019-12-27.html
- Ed Week — Eureka Math Publisher Loses Copyright Battle: https://www.edweek.org/policy-politics/eureka-math-publisher-loses-in-copyright-battle-against-office-depot/2019/12
- New America — New York Curriculum Winds Up in Court: https://www.newamerica.org/weekly/new-york-curriculum-winds-courtand-school-districts-win/
- Eric Goldman Blog — Great Minds v. FedEx analysis: https://blog.ericgoldman.org/archives/2017/02/copyshop-covered-by-non-commercial-creative-commons-license-great-minds-v-fedex.htm
- Stanford Copyright & Fair Use Center — Great Minds v. Office Depot: https://fairuse.stanford.edu/case/great-minds-v-office-depot-inc/
- Creative Commons Legal Database — Great Minds v. Office Depot: https://legaldb.creativecommons.org/en/cases/14/
- IPKat — CC License analysis: https://ipkitten.blogspot.com/2020/01/a-creative-commons-licensed-work-walks.html
- Illustrative Mathematics Trademark Policy: https://illustrativemathematics.org/im-trademark-usage-policy/
- IM Copyright Notice (via ASSISTments): https://www.assistments.org/copyright-notice/illustrative-mathematics-copyright-notice
- Open Up Resources Licensing: https://www.openupresources.org/help-support/licensing-questions/
- OpenStax License page: https://openstax.org/license/
- OpenStax Commercial Use FAQ: https://help.openstax.org/s/article/Commercial-use-under-the-Creative-Commons-License
- Khan Academy content use policy: https://support.khanacademy.org/hc/en-us/articles/202262954-Can-I-use-Khan-Academy-s-videos-name-materials-links-in-my-project
- CK-12 Curriculum Materials License: https://info.ck12.org/curriculum-materials-license
- Education Week — Can an Open Math Curriculum Compete: https://www.edweek.org/teaching-learning/can-an-open-math-curriculum-compete-with-commercial-publishers/2017/08
- Amplify acquires Desmos: https://amplify.com/news/amplify-acquires-desmos-curriculum-to-build-the-future-of-math-instruction-desmos-calculators-to-remain-independent-and-free-to-all/
