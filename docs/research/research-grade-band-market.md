# Grade Band & Go-to-Market Research: Paper Math Companion App

*Research compiled March 2026. Sources noted throughout.*

---

## Executive Summary

The sweet spot for a phone-camera-based paper math companion is **grades 3–8**, with the strongest product-market fit at **grades 4–7** (ages 9–13). This range captures the moment when:

- A meaningful portion of students have personal smartphones or tablets, or access to school-issued devices
- Math difficulty spikes and parent frustration peaks (multi-digit operations, fractions, ratios, pre-algebra)
- Curriculum is still substantially district-adopted at elementary but begins to fragment at middle school
- Parent involvement with homework is still active but often limited by unfamiliar methods

The go-to-market model recommendation is **B2T (teacher-direct freemium) as the entry wedge**, with B2C (parent/student subscription) as the monetization layer. High school is a plausible secondary market with a leaner B2C-direct model, but elementary school is a harder B2B sale and relies on school-issued devices rather than personal phones.

---

## 1. Device Access by Age and Grade

### Smartphone Ownership Rates

Personal smartphone ownership among US children follows a steep adoption curve through the middle school years:

| Age | Approx. Grade | Smartphone Ownership |
|-----|--------------|----------------------|
| 8   | 3rd           | ~24% (1 in 4)        |
| 10  | 5th           | ~33% (first phone at age 10 for ~1/3 of eventual owners) |
| 11  | 6th           | ~53%                  |
| 12  | 7th           | ~69%                  |
| 13  | 8th           | ~75–80%               |
| 15–17 | 9th–12th  | ~98%                  |

Sources: Pew Research Center (Oct 2024); Common Sense Media 2025 Census; EdWeek (Feb 2025); Stanford Medicine first-phone data (avg age 11.6).

Key finding: **The median age for first smartphone is 11–12 years old** (approximately 6th grade). By 8th grade, ~75–80% of students have their own device. By high school, ownership is essentially universal at 95–98%.

The implication: a phone-camera app relying solely on the student's personal device **excludes most elementary students** and a substantial minority of 5th–6th graders, particularly in lower-income households.

### Tablet Ownership (Younger Children)

Tablets follow a different curve and arrive much earlier:

- More than half of children have their own personal tablet before entering kindergarten
- 40% of children ages 0–8 have a personal tablet (Common Sense Media 2025)
- 78% of elementary students regularly use a tablet (personal or shared)

Tablets are a plausible companion device for upper elementary (grades 3–5) where smartphones are rare. An iPad-first positioning for grades 3–5 would capture significantly more of the addressable student population than a phone-only approach.

### School-Issued Devices (1:1 Programs)

The pandemic-era expansion of 1:1 device programs dramatically changed device access in schools:

- Middle school and high school: ~90% of classrooms now have 1:1 device access
- Grades 3–5: ~86% of classrooms have 1:1 access
- K–2: typically shared carts rather than individual assignment; iPads common in K–1

The dominant school-issued device is the **Chromebook** (grades 4–12 in most districts), not an iPhone or iPad. School Chromebooks do not have cameras suitable for the intended use case of a phone-camera companion app, and iOS apps do not run on Chromebooks. School-issued iPads (common in K–3) could be relevant for younger grades but are typically locked down with MDM profiles that restrict app installs.

**Implication:** School-issued 1:1 devices mostly do not solve the device access problem for this app concept. The camera-based feature requires a personal iOS device or a parent/guardian's phone.

### Device Access and Income Disparities

The digital divide persists with meaningful differences by income:

- High-income students (>$100K/yr): 92% own a laptop; broad device access
- Low-income students (<$36K/yr): 76% own a laptop; 1 in 4 rely solely on a smartphone as their only internet-connected device
- Low-income students are more likely to be smartphone-only, which paradoxically could be an advantage for a phone-camera app—but also means they may be on Android, not iOS
- Title I elementary schools: only 25% of students use school-issued devices

The smartphone-only phenomenon in lower-income households slightly increases relative smartphone access vs. PC access, but iOS-specific design may create equity issues since Android is more common in lower-income demographics.

---

## 2. Math Curriculum Purchasing Patterns

### Elementary (K–5): District-Driven, Long Cycles

Elementary math curriculum adoption is predominantly a **district-level decision** with multi-year cycles:

- Only ~36% of elementary schools use exclusively high-quality math curriculum (EdReports definition); 45% use at least one high-quality program
- District adoption cycles are typically 5–7 years; once a curriculum is selected, it is used across all schools in the district
- Recent top-rated programs (per EdReports 2024): i-Ready Classroom Mathematics, enVision Mathematics, Eureka Math/EngageNY, Illustrative Mathematics K–5
- Supplementary tools at elementary level are also often district-purchased or at minimum district-approved

**Who decides:** Curriculum directors and district administrators, typically with a committee that includes instructional coaches and representative teachers. Individual classroom teachers have limited authority to choose core materials.

**Implication for go-to-market:** Selling a companion tool into elementary schools requires navigating district procurement. This is a 12–18 month sales cycle with competitive bidding requirements for purchases above threshold amounts (typically $5,000–$25,000 depending on state). Small supplementary apps are sometimes purchased at the school level, but anything used at scale across classrooms requires district involvement.

### Middle School (6–8): Mixed Adoption, Fragmentation Beginning

Middle school curriculum adoption shows more variation:

- 40% of middle schools use at least one high-quality math curriculum (EdReports data), up from ~22% using exclusively high-quality programs
- NYC's 2024 "NYC Solves" initiative mandated Illustrative Mathematics across 93 middle schools — an example of top-down district enforcement, but this is the exception, not the norm
- Decision-making involves teachers, department heads, instructional coaches, and district curriculum staff collaboratively
- NYC example: 14 teachers from multiple high schools piloted curricula over a full year before district adoption

**The fragmentation point:** Middle school is where teacher autonomy over supplementary materials begins increasing meaningfully. Department chairs have more influence than at elementary, and individual teachers have more latitude to adopt supplementary digital tools, especially free ones.

### High School (9–12): Teacher-Driven, Self-Sourced Materials

This is where the original insight holds up strongly in the data. A 2024 national survey of 1,000+ math teachers, presented at the American Educational Research Association annual meeting (April 2024) and reported by the Hechinger Report, found:

- Many high school math teachers **do not use the district-provided materials at all** — a "surprising number" explicitly said they don't use school-provided materials or claimed they didn't have any
- 19% of teachers surveyed are "DIY teachers" who create their own curriculum entirely
- Math teachers are more likely to be "modifiers" — making considerable changes to a single curriculum or supplementing heavily
- TeachersPayTeachers (TPT) skews elementary, but high school math teachers are heavy internet scrapers

**What EdReports data shows about high school:** EdReports reviews high school curriculum, but the research doesn't show the same rate of formal district adoption as at elementary. High school math is more subject-specific (Algebra I, Geometry, Algebra II, Precalc, Calc, Statistics) with more curricular fragmentation by course, and teachers with advanced math degrees tend to have stronger opinions about pedagogy and materials.

**Implication:** At the high school level, a **B2C or B2T (freemium teacher-direct)** go-to-market is genuinely more viable than B2B district sales, because:
1. District adoption of a single high school math curriculum is less common and less locked-in
2. Individual teachers have purchasing authority for low-cost tools (<$500/year is often within discretionary budgets)
3. Teachers will share tools that work; word-of-mouth in a math department spreads faster than in elementary schools

---

## 3. Edtech Go-to-Market Models

### B2C (Parent or Student Direct)

**How it works:** App is marketed to parents or students; individual purchases via App Store or web subscription. No school involvement required.

**Benchmark examples:**

- **Photomath** (acquired by Google, finalized Feb 2024): 300M+ users globally; $50M Photomath Plus revenue in 2024; ~$35M ARR as of Jan 2025. Pure B2C freemium (free scan + solve; paid for step-by-step explanations and animated video lessons). Demographic: middle school through college.
- **IXL**: $9.95/month consumer subscription; also sold B2B to districts. Used by both families and schools. Strong parent-direct channel.
- **Duolingo Math** (launched Oct 2022): leverages Duolingo's 45M DAU freemium base; parents are the primary Family Plan subscriber demographic. Duolingo overall achieves 8.8% freemium-to-paid conversion vs. industry average of ~2–3%.
- **Khan Academy / Khanmigo**: Free (nonprofit donation-funded); Khanmigo AI tutoring at $4/month for parents/students. Primarily B2C but also B2B for districts.

**Deal sizes:** Consumer edtech subscriptions typically price at $5–$20/month or $50–$150/year per family. Photomath Plus is ~$10/month or $70/year. IXL is $9.95/month or $79/year.

**Strengths for this app:**
- No school approval needed; parent can download tonight
- Parents of elementary/middle schoolers are already paying for tutoring, learning apps, and extracurriculars — this is familiar spend
- iOS App Store allows direct revenue capture with strong payment infrastructure

**Weaknesses:**
- CAC (customer acquisition cost) is high for B2C consumer ed; paid social is expensive and churn is high
- Requires large user numbers to generate meaningful revenue at $10/month price points
- Parents may not know about the app unless teachers recommend it

### B2T (Teacher-Direct Freemium)

**How it works:** App is free for teachers (and optionally free for students); teachers assign it as part of homework or practice. Teacher adoption drives student adoption. Monetization comes from premium features, school/district licenses, or parent upgrade.

**Benchmark examples:**

- **Desmos**: Free graphing calculator + curriculum tools; profitable since 2012 through B2B licensing to publishers and assessment companies (integrated into SAT, ACT, 35 state assessments). 75M+ users. The canonical example of free-to-teacher → scale → B2B licensing.
- **Nearpod**: Used by 60% of US school districts; started with teacher adoption, moved to district licensing. Free teacher tier; paid school/district tiers.
- **Kahoot!**: Grassroots teacher adoption → 97% of Fortune 500 companies for training (B2B expansion). Free for teachers; paid for premium features.
- **Zearn**: Free for individual teachers and families; negotiated pricing for schools and districts. Works at both B2C and B2T levels.
- **Quizlet**: Teacher assigns; students use free version; parents sometimes upgrade to paid.

**Strengths for this app:**
- Teachers recommending a tool to parents is the most efficient distribution channel for a homework companion (parents trust teacher judgment)
- Free teacher tier removes the budget/approval barrier for teacher adoption
- A single teacher assigning to a class of 25 generates 25 potential parent users
- High school teachers with autonomy are prime early adopters

**Weaknesses:**
- Takes time to build teacher base; requires teacher-facing marketing (conferences, word-of-mouth, TPT presence)
- Schools may restrict what apps teachers can recommend to students/parents
- Teacher-to-parent funnel has conversion loss at each step

### B2B (District/School Direct Sales)

**How it works:** Sales team engages district curriculum directors, technology coordinators, or principals. Typically involves procurement, pilots, and multi-year contracts.

**Typical deal structure:**
- Sales cycle: **6–18 months** minimum; often 12–18 months from first contact to revenue
- Districts begin budget assessment in May for the following year; November–April is the intensive vendor research phase
- Competitive bidding requirements kick in above ~$5,000–$25,000 thresholds (varies by state)
- Purchases often tied to ESSER funds (now mostly exhausted as of 2024), Title I funds, or curriculum line items
- Typical deal sizes: $5–$50 per student per year at scale; small district (3,000 students) = $15K–$150K/year; large district (50,000 students) = $250K–$2.5M/year

**Elementary B2B:** Standard path but slow. The district controls the relationship, holds the budget, and can require pilots, evidence of efficacy, and multi-stakeholder approval. ESSER fund exhaustion in 2024 has tightened district discretionary budgets significantly.

**High school B2B:** Less viable (see Section 2 above). High school math lacks the district-wide curriculum coordination of elementary school, and purchase decisions are more fragmented.

**When B2B makes sense for a supplementary tool:** When the tool is positioned as a curriculum supplement tied to the adopted curriculum (e.g., "works with Eureka Math"), when there's a strong efficacy story, or when the tool is being sold to the principal or department head rather than the district office (smaller deal, faster cycle, but limited scale).

### Which Model Fits a Paper Math Companion Best?

For a camera-based homework companion, the evidence points to a **layered model**:

1. **Launch with B2T freemium:** Target middle and high school math teachers first. Free teacher access. Teachers assign it as a "scan your paper and check your work" tool. This generates student users and exposes the product to parents organically.

2. **Monetize via B2C parent subscription:** Parents who see their child using the app (or who are struggling to help with homework) are the paying customer. Price at $8–$12/month or $70–$100/year. This is consistent with Photomath Plus pricing and parent willingness-to-pay in the edtech market.

3. **Expand to B2B school licensing** only after achieving scale (100K+ active users): At that point, the product has proof points and teachers are already advocates, making district conversations credible.

---

## 4. Parent Involvement by Grade Level

### When Parents Are Most Active in Math Homework

Research on parental homework involvement shows a clear grade-band pattern:

**Elementary (K–5): Peak involvement, high frustration**
- 83% of parents of K–2 students feel homework load is "about right" — but they are actively helping
- Parental involvement in homework is highest in elementary school and declines sharply through middle school
- Parents of children in grades 1–6 are the primary demographic studied for math homework anxiety research
- ~60% of parents report struggling to help with K–8 homework

**Middle School (6–8): Active disengagement by design**
- The prevailing parenting advice — and the research backing it — supports stepping back in middle school to build student independence
- "By middle school, students should be doing most, if not all, of their work on their own" is the standard guidance
- Parent involvement in homework declines steeply in grades 6–8
- However, parents remain highly attentive to grades and outcomes, even if not sitting alongside kids

**High School (9–12): Minimal direct involvement**
- Research shows the "intrusive" effect of parental homework help is strongest in high school — when parents try to help, it often backfires
- High schoolers largely resist parental involvement in academics
- Parents may pay for tutoring but rarely sit beside teens for homework

### Where Parent Math Frustration Peaks

The research is clear that **parent math anxiety is a real and documented phenomenon** with downstream effects on children's math achievement:

- Parents higher in math anxiety report more negative emotional experiences around homework
- When homework interactions are "fraught with negativity such as parental feelings of frustration or ineptitude," children score lower on math achievement tests a year later (University of Illinois research)
- "Many parents felt frustrated about helping with math homework due to their unfamiliarity with current curricula and teaching methods" — this is the "area model" / "number bond" / "lattice multiplication" problem
- Approximately 60% of parents report struggling to help with K–8 math homework

**The "I don't know what an area model is" problem:** This frustration is well-documented and peaks in **grades 3–6**, where Common Core-aligned curricula (adopted broadly after 2010) introduced unfamiliar representations and algorithms. Parents who learned traditional algorithms face alien-looking homework. This is a genuine pain point and a plausible motivation for a camera-based "help me understand what my kid is doing" product.

**Key insight for product positioning:** The parent use case may be as strong as the student use case for grades 3–7. A parent who can point a phone at their child's math homework and get an explanation of what the problem is asking — not just the answer, but the method — addresses a real, emotionally charged pain point. This dual student/parent positioning is distinct from Photomath (student-focused answer checker) and could be a meaningful differentiator.

---

## 5. Synthesis: Recommended Grade Band and GTM Model

### Target Grade Band: 4–8 (Primary), 9–12 (Secondary)

**Grades 4–8 (ages 9–14): Primary target**

This band offers the best intersection of:
- Device access: tablets are near-universal; personal smartphones reach 50–70%+ by grades 6–8
- Math complexity: content difficulty spikes (multi-digit, fractions, ratios, proportions, pre-algebra) where both students and parents struggle
- Parent engagement: parents are still involved but increasingly out of their depth
- Curriculum landscape: district-adopted but with room for supplementary tools, especially in middle school
- Teacher openness: middle school math teachers have more autonomy than elementary to recommend tools

**Grades 9–12 (ages 14–18): Secondary target via B2C/B2T**
- Near-universal smartphone ownership removes device access as a barrier
- High school math teachers operate with significant autonomy and are not locked into district curricula
- B2C (student/parent direct) and B2T (teacher freemium) are both viable without district sales
- Students are more likely to self-discover and self-purchase
- Parent involvement is low, so the product must appeal to the student directly
- Photomath already owns much of this space; positioning needs to be differentiated (paper workflow support, not just answer checking)

**Grades K–3 (ages 5–9): Exclude from initial launch**
- Personal smartphone ownership is very low (under 25%)
- School-issued devices (when available) are Chromebooks that won't run iOS apps
- District and school gatekeeping is strongest at elementary
- The product would need to be sold to districts, not parents or teachers
- Parent frustration is real but the app delivery mechanism doesn't reach students reliably

### Recommended GTM Sequence

**Phase 1 — Teacher-Direct Freemium (B2T):**
- Free tier for teachers: class management, assignment integration, progress visibility
- Target middle school (6–8) and high school (9–12) math teachers
- Channels: teacher influencers on social/YouTube, math teacher Twitter/Reddit communities, TPT presence, math education conference presence (NCTM)
- Conversion hook: teachers share with parents; parents see the product in use

**Phase 2 — Parent/Student Subscription (B2C):**
- Premium tier at $8–$12/month or $70–$100/year for parents
- Features: unlimited scans, step-by-step explanations of the specific method used on the paper (area model, number bond, etc.), parent dashboard showing what concepts are in the homework
- Target parent acquisition via App Store featuring, word-of-mouth from teachers, and targeted ads to parents of 4th–8th graders

**Phase 3 — District Licensing (B2B, opportunistic):**
- Only pursue once product has proven usage metrics and teacher advocates
- Position as "companion to your adopted curriculum" (e.g., "works with Illustrative Mathematics")
- Focus on middle school districts first; avoid elementary-only district sales until scale achieved

### Comparable GTM Trajectories

| Company | Starting GTM | Monetization | Notes |
|---------|-------------|--------------|-------|
| Photomath | B2C (app store) | Freemium subscription | 300M users; acquired by Google |
| Desmos | B2T (free tools) | B2B licensing (publishers, assessments) | Profitable since 2012 |
| Nearpod | B2T (free teacher) | B2B school/district | 60% US district penetration |
| Khan Academy | B2C + donations | Nonprofit; Khanmigo $4/mo AI tier | Massive awareness; hard to replicate |
| IXL | Dual B2C + B2B | $9.95/mo consumer; district licensing | Both channels at scale |
| Zearn | B2T (free teacher) | Freemium family + negotiated district | Elementary-focused; strong district relationships |

---

## Key Data Points for Decision-Making

1. **53% of 11-year-olds have smartphones; 69% by age 12.** This places the natural device-access floor at grades 6–7 for phone-specific features.

2. **Tablets close the gap for grades 3–5.** If the app runs well on iPad, the addressable market expands meaningfully downward.

3. **High school math teachers are genuinely self-sourcing materials** — a 2024 AERA survey found many simply don't use district materials. This validates B2T/B2C for grades 9–12.

4. **District sales cycles are 6–18 months** with the heaviest concentration of budget decisions in May–October each year. ESSER fund exhaustion in 2024 has tightened district budgets.

5. **~60% of parents struggle to help with K–8 math homework.** Parent math anxiety is a real, documented, emotionally significant problem — a product that helps parents understand their child's homework (not just get the answer) addresses something Photomath does not.

6. **Freemium conversion benchmarks:** Industry average is 2–3%; Duolingo achieved 8.8% with intentional design. A well-designed math homework companion could target 4–6% conversion if the free tier creates habit and the paid tier delivers clear additional value.

7. **Photomath's $50M paid revenue (2024) from a B2C freemium model** is the clearest existence proof that parents and students will pay for camera-based math help. Positioning as a complementary workflow tool (paper-first, method-explaining) rather than a direct competitor is essential.

---

*Research sources: Pew Research Center Teens & Technology 2024; Common Sense Media 2025 Census (0–8); EdWeek Feb 2025 (elementary device ownership); Stanford Medicine first phone age study; ACT Digital Divide report (2024); Hechinger Report AERA 2024 survey; EdReports Data Snapshot K–12 Math; RAND curriculum professional learning research; Duolingo 2024 annual report / subscriber data; Photomath TechCrunch / Crunchbase funding and revenue data; EdWeek / MarketBrief K–12 sales cycle reporting; FasterCapital / Oser Communications edtech sales cycle analysis; Frontiers in Psychology parental homework involvement meta-analysis (2023); MDPI parental math anxiety research; University of Illinois homework-help-emotions study.*
