# Competitive Landscape: Math Learning Apps with Camera Input and AI Tutoring

**Research Date:** March 2026
**Purpose:** Competitive analysis for paper-math-companion concept development

---

## Overview

The camera-based math app space is dominated by a small number of well-funded incumbents, all of which converge on the same core use case: point camera at problem, get answer (and maybe steps). None of them do what a good tutor does — evaluate the student's own work, explain the strategy by name, decompose a concept into prerequisite skills, or serve the parent who is trying to *understand* what their kid is being asked to do.

---

## Direct Competitors: Camera-Based Math Apps

### 1. Photomath (Google)

**Background**
Founded in Croatia in 2014; acquired by Google for ~$550M, announced May 2022, officially completed June 2023. Now officially branded as a Google product on the Play Store.

**What it does**
- Point camera at a printed or handwritten math problem; OCR recognizes it and delivers step-by-step solutions
- Covers arithmetic through calculus, including word problems and graphs
- Offers *multiple solution methods* for the same problem (this is a genuine differentiator — e.g., shows both FOIL and the box method for polynomial multiplication)
- Animated tutorials explain *why* steps work, not just what they are
- Localized in 32 languages

**Pricing**
- Free tier: basic answers, limited step visibility
- Photomath Plus: $9.99/month or $69.99/year — unlocks full textbook solutions, animated tutorials, extended explanations for word problems

**App Store ratings**
- Apple App Store: 4.6/5 from 729,000+ ratings
- Google Play: 4.2/5 from 3 million+ reviews

**What it does well**
- Best-in-class OCR and camera recognition
- Multiple solution methods shown side by side
- Free step-by-step for most standard problems
- Genuinely useful for parents to decode homework problems

**Where it stops short**
- No conversational follow-up — it is a one-way pipeline: photo in, steps out
- Cannot evaluate or analyze the student's own work or scratch work
- Does not identify *why* a student got something wrong
- Does not decompose a problem into prerequisite sub-skills
- No scaffolded practice generation
- No strategy naming (e.g., it shows the "make a ten" approach without calling it that)
- Subscription paywall complaints are the #1 negative review theme
- Camera struggles with laminated pages, stylized handwriting, script

**Pedagogical approach**
Shows the *how*, not the *why*. No Socratic method. Not adversarial to answer-copying — teachers cite this as the primary misuse concern.

---

### 2. Mathway (Chegg)

**Background**
Owned by Chegg; positioned as a broad homework-help platform rather than a standalone learning tool.

**What it does**
- Text entry, photo scan, or voice input
- Covers algebra through calculus, plus physics and chemistry solvers
- Graphing calculator built in
- Available as both a web app and mobile app

**Pricing**
- Free tier: answers only, heavy ads
- Premium: $9.99/month or $39.99/year — unlocks step-by-step solutions

**App Store ratings**
- Google Play: 4.9/5 (surface rating; deep reviews tell a different story)
- Trustpilot: 1.7/5 — dominated by subscription billing complaints, difficulty canceling, and non-responsive support

**What it does well**
- Very broad subject coverage beyond math
- Graphing is notably good
- Clean interface

**Where it stops short**
- Deliberately gates step-by-step behind paywall — free version is almost useless for learning
- No Socratic method or guided questioning
- No follow-up interaction
- No work evaluation
- No practice generation
- Accuracy issues reported (students have received wrong answers)
- The billing and cancellation experience is the primary reputation problem
- App has a known bug where it stops functioning after ~10 minutes and requires reinstall

**Pedagogical approach**
Answer machine with an expensive subscription to see the steps. The most passive of the major players.

---

### 3. Socratic by Google

**Background**
Acquired by Google in 2018. As of 2025, Socratic's functionality has been partially merged into Google Lens, though the standalone app still exists.

**What it does**
- Photo input triggers a search-like experience: the app identifies the topic and surfaces relevant explanations, videos, diagrams, and web resources
- Uses Khan Academy videos, curated web explanations, and "info cards" for key concepts
- Covers math, science, history, literature — a generalist homework helper

**Pricing**
- Completely free — no subscription tiers

**App Store ratings**
- Generally positive; rated as a solid tool for basic to intermediate math

**What it does well**
- Strong at answering "why?" — links to conceptual explanations, not just procedural steps
- Free with no upsell
- Good for subjects beyond math
- Better for younger students who need conceptual grounding

**Where it stops short**
- Not strong on complex or advanced math
- Photo recognition is weaker than Photomath for handwriting
- Functions more as a curated search engine than an interactive tutor
- No conversational interaction
- No work evaluation
- No practice generation
- Laminated pages and non-standard formatting cause recognition failures

**Pedagogical approach**
Closest to "why?" but achieves it via curation, not conversation. Good for conceptual orientation, not procedural mastery.

---

### 4. Microsoft Math Solver

**Background**
Discontinued as a standalone app in July 2025. Math Solver features now live in Microsoft Edge's built-in tools and web-based platforms. Worth noting as a historical data point.

**What it did**
- Camera scan, handwriting recognition (stylus), on-screen drawing, and typed input
- Step-by-step solutions with interactive graphs
- Linked to Khan Academy videos for related concepts
- Generated practice problems on the same topic

**Pricing**
- Completely free

**What it did well**
- Practice problem generation was a notable feature (rare in the category)
- Khan Academy video linking was useful for parents/students wanting deeper context
- Handwriting recognition via stylus was ahead of peers
- Accessibility features: immersive reader, whiteboard mode, multi-language support

**Where it stopped short**
- Plagued by "application errors" — reliability was a consistent complaint
- No conversational interaction
- No work evaluation
- Eventually discontinued, suggesting it didn't achieve sufficient engagement

**Pedagogical approach**
Answer + steps + practice problems. The closest any of the direct competitors came to scaffolded practice, but it was additive (more problems) rather than truly adaptive (prerequisite skill decomposition).

---

### 5. Gauth (formerly Gauthmath, ByteDance)

**Background**
Built by ByteDance (TikTok's parent company). Rebranded from Gauthmath to Gauth and expanded scope to include multiple subjects and a human-expert escalation path.

**What it does**
- Camera-based problem capture with strong OCR
- Step-by-step AI solutions with a chat follow-up feature
- Option to escalate to a live human expert (paid)
- Covers math from algebra through calculus; also physics and chemistry
- AI chat allows some follow-up questions after the initial solution

**Pricing**
- Freemium: free to download, limited daily questions with ads
- Paid tiers increase question limits and add features; specific pricing varies by region
- Human expert access is pay-per-use on top of subscription

**App Store ratings**
- Generally strong; ~90-95% accuracy on standard homework problems reported in testing

**What it does well**
- Notably good OCR — handles varied handwriting and lighting conditions well
- Post-solution chat is a meaningful step beyond Photomath and Mathway
- Human expert escalation is unique in the space
- Multi-subject breadth

**Where it stops short**
- Chat follow-up is limited — it answers clarifying questions but doesn't guide the student through *their* work
- No work evaluation (cannot analyze what the student wrote)
- No scaffold/practice generation
- No strategy naming
- Human expert option makes it the most expensive option at scale
- ByteDance provenance raises data privacy concerns in K-12 contexts

**Pedagogical approach**
The most interactive of the direct competitors. Chat follow-up is a genuine differentiator, but it's still fundamentally a "here's how to solve this problem" tool.

---

### 6. Symbolab

**Background**
Acquired by Chegg in 2020 (same parent as Mathway). More technically oriented than Mathway — aimed at high school and college students.

**What it does**
- Typed input or camera scan
- Step-by-step solutions with high mathematical rigor
- Graphing calculator
- Practice problems and progress tracking
- Problem history saved for review

**Pricing**
- Free tier: limited steps
- Symbolab Pro: $6.99/month, $24.90 semi-annual, or $29.99/year

**What it does well**
- High accuracy and rigor for advanced math (calculus, linear algebra)
- Progress tracking is above average
- Practice problem library is meaningful

**Where it stops short**
- No camera-first UX (primarily typed input)
- No conversational interaction
- No work evaluation
- No strategy naming or conceptual explanation for younger learners
- Owned by Chegg alongside Mathway — limited incentive to differentiate

**Pedagogical approach**
Technically rigorous answer tool. Best for college students; not well-suited to K-8.

---

## AI Education Companies

### 7. Khanmigo (Khan Academy)

**Background**
Launched 2023 in partnership with OpenAI. Khan Academy's flagship AI product, built on their 15+ years of learning content and mastery-based progression data.

**What it does**
- Socratic tutoring: asks guiding questions rather than giving direct answers
- Integrates directly with Khan Academy's exercise system — when a student is working on a problem set, Khanmigo can see which exercise they're on
- Image upload support (web version) — student can share a picture, but must accompany with a text question
- Speech-to-text and text-to-speech
- Writing feedback that comments without rewriting
- Teacher tools: lesson planning, differentiated instruction, assessment generation

**Pricing**
- Free for teachers (fully featured teacher tools)
- $4/month or $44/year for parents and learners

**App Store / Review ratings**
- Common Sense Media: 4/5 stars
- Generally rated 8-8.5/10 by independent reviewers

**What it does well**
- The most pedagogically rigorous consumer-facing AI tutor in the market
- Genuinely guided: challenges students to think, doesn't hand over answers
- Integration with Khan Academy exercise content means it has context about what the student is struggling with
- Very affordable
- Strong teacher reporting and progress visibility

**Where it stops short**
- Mobile app does not support image input — must use web
- No camera-native experience; it's a chat interface, not a "point at paper" experience
- Image input requires text accompaniment (cannot submit image-only)
- The Socratic guidance can frustrate students who just want the answer
- Does not evaluate the student's own written work
- No strategy naming or "what's this method called" explanations
- Practice generation follows Khan Academy's pre-built sequences, not adaptive decomposition from a novel problem

**Pedagogical approach**
The gold standard for guided Socratic tutoring in the consumer space. The primary gap: it lives entirely in a chat paradigm. No paper-to-screen bridge.

---

### 8. MagicSchool AI (Denver-based)

**Background**
One of the fastest-growing edtech companies in the US, primarily teacher-facing. Not student-facing in the traditional consumer sense. Positioned as the teacher's AI workflow tool for lesson planning, assessment creation, and classroom content generation.

**What it does**
- 80+ AI tools for teachers: lesson plan generation, rubric creation, differentiated instruction materials, parent communication drafts, IEP support, etc.
- MagicStudent: a sandboxed student environment where teachers assign specific, pre-vetted AI tools within "Rooms"
- "Tutor Me" feature: AI asks Socratic questions rather than giving answers
- Math Spiral Review: generates cumulative practice problems
- Strong compliance: COPPA, FERPA, GDPR compliant

**Pricing**
- Freemium; district/school licensing for full access
- Individual teacher free tier is generous

**Is it student-facing for math tutoring?**
Marginally. MagicStudent exists but is teacher-mediated — students access it through a teacher's assigned Room. The math content warning from Common Sense Education notes MagicSchool AI should not be used to *compute* math answers, as it is unreliable for calculation. It is a content generation and pedagogical planning tool, not a math solver.

**What it does well**
- Unmatched for teacher workflow automation
- Spiral review generator is useful for practice creation
- Safe, compliant student environment

**Where it stops short**
- No camera input of any kind
- No paper-to-screen workflow
- Not designed for a student to independently work through a problem
- Math computation is explicitly unreliable — not a solver
- The parent use case is entirely absent

**Pedagogical approach**
Teacher-mediated learning tool. The student experience is a downstream product of teacher setup, not an independent student-driven flow.

---

### 9. Third Space Learning (Skye AI Tutor)

**Background**
UK-based; 12 years of school-based tutoring experience. Recently launched Skye, an AI math tutor for elementary students (UK: Years 4-6), now expanding to the US market.

**What it does**
- One-to-one scaffolded AI math lessons
- Structured using "I do, We do, You do" lesson format
- CRA (Concrete-Representational-Abstract) pedagogical approach
- Scaffolded hints and support that fade as student gains independence
- Teacher oversight and progress reporting

**Pricing**
- School/district licensing; not a consumer app

**What it does well**
- The most pedagogically sophisticated scaffolding of any product in the space
- Actually teaches prerequisite concepts when a student is stuck
- Built by math educators, not engineers

**Where it stops short**
- B2B school channel only — not available for individual family purchase
- No camera/paper input
- US availability and pricing not clearly established
- Limited to elementary math

**Pedagogical approach**
The closest thing in the market to what a human specialist math tutor does. The gap: it requires a school relationship and has no paper-to-app bridge.

---

## Competitive Analysis by Key Questions

### 1. Which apps offer guided/Socratic problem solving vs. just showing the answer?

| App | Approach |
|-----|----------|
| Photomath | Shows answer + steps. No guidance or questioning. |
| Mathway | Shows answer only (free). Steps behind paywall. No guidance. |
| Socratic | Conceptual orientation via curation; no interactive guidance. |
| Microsoft Math Solver | Shows answer + steps + related videos. No guidance. |
| Gauth | Shows answer + steps + limited post-solution chat. |
| Symbolab | Shows answer + rigorous steps. No guidance. |
| Khanmigo | **Genuinely Socratic** — asks guiding questions, withholds direct answers. |
| MagicSchool (Tutor Me) | Asks Socratic questions but limited math computation reliability. |
| Third Space Learning (Skye) | **Fully scaffolded** — I do/We do/You do with fading support. |

**Finding:** Among consumer-accessible apps, Khanmigo is the only one with genuine Socratic guidance. All camera-based tools give answers.

---

### 2. Which support follow-up interaction (student shows work, app evaluates)?

**Short answer: None of them do this well.**

- **Photomath**: No conversational follow-up. One-way pipeline.
- **Mathway**: No conversational follow-up.
- **Socratic**: No interactive follow-up.
- **Gauth**: Post-solution chat lets students ask follow-up questions, but the app cannot analyze or evaluate the student's own written work.
- **Khanmigo**: Image upload allows student to share their work, but requires text prompts; works via web, not native mobile camera; the model can comment on student work but this is not the primary UX flow.
- **Third Space Learning**: Scaffolded guidance responds to student answers in real time, but within a controlled lesson flow, not a free-form "here's my scratch work" interaction.

**Finding:** No app in the market lets a student photograph their own scratch work or paper and receive meaningful feedback on *what the student did* — only on what the *correct solution* is.

---

### 3. Do any offer scaffolded practice generation (decompose into sub-concepts, build up)?

- **Microsoft Math Solver** (now discontinued): Generated related practice problems, but additively (more of the same type), not adaptively.
- **Symbolab**: Practice library exists with some progression, but not adaptive decomposition.
- **Khanmigo**: Uses Khan Academy's pre-built mastery sequences; adapts within those sequences but cannot decompose a novel problem into its prerequisite sub-skills on the fly.
- **Third Space Learning**: The closest — lessons are built around prerequisite progressions. But school-only B2B channel.
- **MagicSchool Math Spiral Review**: Generates practice problems on related topics but is teacher-facing, not student-facing.

**Finding:** No consumer app can take a specific problem a student is stuck on and dynamically generate scaffolded practice that builds up the prerequisite skills. This is a significant gap.

---

### 4. Do any serve the "parent decoder" use case?

The "parent decoder" use case: parent sees their kid's homework, doesn't recognize the method being taught, wants to understand (a) what strategy is being used, (b) why, (c) how to help without confusing the child by showing a different approach.

- **Photomath**: Comes closest incidentally — shows multiple solution methods, and parents use it to decode homework. But it doesn't name strategies, explain *why* this method is taught, or contextualize it in a curriculum framework.
- **Socratic**: Links to conceptual explanations that sometimes help parents. Not designed for this use case.
- **All others**: No explicit parent support features.
- **Common Core resources** (websites, books): These exist but are not integrated into any app.

**Finding:** No app explicitly targets the parent who doesn't recognize what method their child is learning. Parents use Photomath as a workaround, but it's an accident of design, not intentional. The strategy-naming layer — "this is the partial products method" or "this is make-a-ten" — is completely absent from every app in the market.

---

### 5. Pricing and Business Models

| App | Free Tier | Paid | Model |
|-----|-----------|------|-------|
| Photomath | Basic answers, limited steps | $9.99/mo or $69.99/yr | Freemium consumer |
| Mathway | Answers only, heavy ads | $9.99/mo or $39.99/yr | Freemium consumer (Chegg) |
| Socratic | **Fully free** | None | Google-subsidized |
| Microsoft Math Solver | Was fully free | Discontinued July 2025 | Was Google-subsidized (Microsoft) |
| Gauth | Limited questions, ads | Regional pricing; human expert add-on | Freemium consumer (ByteDance) |
| Symbolab | Limited steps | $6.99/mo or $29.99/yr | Freemium consumer (Chegg) |
| Khanmigo | Free for teachers | $4/mo or $44/yr (families) | Non-profit subsidized |
| MagicSchool AI | Teacher free tier | District licensing | B2B SaaS |
| Third Space Learning | None | School contracts | B2B SaaS |

**Observations:**
- The $4-10/month range is the established consumer price point for premium math tutoring apps
- Google-subsidized free tools (Socratic) create pricing pressure at the low end
- Khan Academy's $4/month is a powerful anchor — it's the most pedagogically complete and the cheapest paid option
- B2B SaaS (MagicSchool, Third Space) is a different market with different economics

---

### 6. App Store Ratings and Common Complaints

| App | iOS Rating | Android Rating | Top Complaints |
|-----|-----------|----------------|----------------|
| Photomath | 4.6/5 (729K ratings) | 4.2/5 (3M ratings) | Paywall frustration; camera accuracy issues with handwriting; no support for script |
| Mathway | ~4.7/5 | 4.9/5 | Trustpilot 1.7/5; subscription billing/cancellation; accuracy errors; app crashes after ~10 min |
| Socratic | Generally positive | Generally positive | Weak on advanced math; external redirects feel disconnected |
| Microsoft Math Solver | N/A (discontinued) | N/A (discontinued) | Application errors; reliability |
| Gauth | Strong | Strong | Data privacy concerns; variable accuracy on word problems |
| Symbolab | Positive | Positive | Paywall placement; limited for younger students |
| Khanmigo | N/A (web-first) | N/A (web-first) | Guidance can frustrate students wanting direct answers; mobile image input not supported |

**Recurring themes across the category:**
1. Subscription paywalls hiding the feature that actually matters (steps)
2. Accuracy failures on complex or poorly formatted problems
3. No interactive engagement — students use it to copy answers, not to learn
4. Parents and educators express concern about bypassing learning rather than supporting it

---

### 7. Where Is the Whitespace?

Based on this analysis, the following gaps exist — many of them in combination:

**Gap 1: Evaluating student work, not just solving the problem**
Every app in the market takes a *problem* as input and produces a *solution*. Not one of them takes a photo of a student's *attempted work* as input and tells the student what they did right, where they went wrong, and what misconception the error reveals. This is what a human tutor does that no app does.

**Gap 2: Strategy naming and curriculum context**
No app tells you the name of the method being used, why it's taught that way, or how it fits into the grade-level curriculum. Parents are left confused by methods they don't recognize. The strategy layer — "this is partial products," "this is the standard algorithm," "this is the area model" — is invisible in every product.

**Gap 3: The parent use case as first-class**
Parents are either ignored (all camera apps) or entirely excluded (teacher-facing tools). No app says: "Here's what your child is being asked to do, here's the name of the strategy, here's why it's taught this way, and here's how you can help without confusing them." This is a completely unserved user.

**Gap 4: Adaptive prerequisite decomposition**
If a student is stuck on multi-digit multiplication, the gap isn't usually "they don't know multiplication" — it's something more specific (place value, partial products, regrouping). No consumer app can take the problem the student is stuck on, identify the likely prerequisite gap, and build up practice from there. Khanmigo does this within Khan's pre-built mastery sequences; nothing does it dynamically from a novel input.

**Gap 5: Paper-to-screen bridge for interactive tutoring**
Khanmigo is the most pedagogically rigorous interactive tutor in the consumer market — but it's a chat box. It has no camera. You cannot show it your work; you have to describe your work in text. The camera apps have no interaction. Nobody has built the intersection: camera-first interaction where the student's paper is the primary input.

**Gap 6: Elementary and middle school focus**
Most camera apps skew toward high school algebra and above. The parents most confused by "new math" methods are K-6 parents. Photomath's step-by-step is most useful from algebra onward. The elementary math space — where Common Core strategies are most confusing to parents and where early fluency matters most — is underserved in the consumer app market.

---

## Summary Table

| App | Camera | Guided (Socratic) | Evaluates Student Work | Scaffolded Practice | Parent Decoder | Price |
|-----|--------|-------------------|----------------------|--------------------|--------------:|-------|
| Photomath | Yes (best-in-class) | No | No | No | Incidentally | Free / $70/yr |
| Mathway | Yes | No | No | No | No | Free / $40/yr |
| Socratic | Yes | Partial (curation) | No | No | No | Free |
| MS Math Solver | Yes (discontinued) | No | No | Limited | No | Was free |
| Gauth | Yes (strong) | Post-solution chat | No | No | No | Freemium |
| Symbolab | Yes | No | No | Limited | No | Free / $30/yr |
| Khanmigo | Partial (web only) | **Yes** | Partial | Within KA sequences | No | $44/yr |
| MagicSchool | No | Partial | No | Teacher-facing | No | B2B |
| Third Space (Skye) | No | **Yes (best)** | Within lesson | **Yes (structured)** | No | B2B only |

---

## Key Takeaways for Product Development

1. **The camera-solve-explain pipeline is saturated.** Photomath owns it. You cannot out-Photomath Photomath with Google's OCR behind it.

2. **The interaction gap is real and large.** Nobody is doing camera-in + conversation + work evaluation. The two halves (camera and interaction) exist in separate products that don't talk to each other.

3. **The parent is an orphaned user.** Every product in the market either ignores parents or treats them as secondary. The parent who can't decode their kid's homework has no good tool.

4. **Strategy naming is a wide-open lane.** Telling a parent or student "this is the partial products method, and here's why it's taught this way" is something no app does. It would immediately differentiate a product.

5. **Khanmigo proves the market for guided tutoring at $4/month.** The pricing floor is set; it's very low. This suggests volume or B2B are the path to sustainability, not premium individual pricing.

6. **Elementary is underserved.** The confusion, the parent frustration, and the foundational importance are highest in K-6. That's where the need is greatest and the solutions are weakest.
