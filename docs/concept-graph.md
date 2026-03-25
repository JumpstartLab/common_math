# Concept Graph: The Core Data Layer

## What It Is

A directed graph of mathematical concepts that connects every piece of content in the EngageNY curriculum. Nodes are concepts/skills. Edges are dependencies. Every lesson, problem, homework, and assessment links to the concepts it teaches, practices, or requires.

This doesn't exist anywhere — not in EngageNY, not in any curriculum. Teachers carry it in their heads. Building it as structured data is the most valuable and defensible thing in this entire project.

## Graph Structure

### Nodes (Concepts/Skills)

Each node represents a discrete mathematical concept or skill:

```
{
  "id": "mul-area-model",
  "name": "Area Model Multiplication",
  "aliases": ["box multiplication", "rectangular array multiplication"],
  "grade_introduced": 3,
  "description": "Using rectangular area to represent multiplication of two factors",
  "prerequisites": ["arrays", "place-value-hundreds", "distributive-property"],
  "strategies": ["area-model", "partial-products"],
  "ccss_standards": ["3.OA.7", "4.NBT.5", "5.NBT.5"]
}
```

Key fields:
- **aliases** — what different curricula call this concept (the cross-curriculum dictionary)
- **prerequisites** — edges to other nodes (what you need to know first)
- **strategies** — named solution approaches (what parents need to look up)
- **ccss_standards** — Common Core mappings (extendable to state standards)

### Edges (Dependencies)

Directed edges from prerequisite → concept:

```
arrays → area-model-multiplication
place-value-hundreds → area-model-multiplication
distributive-property → area-model-multiplication
area-model-multiplication → multi-digit-multiplication
```

Edge types:
- **requires** — you must understand A before B
- **builds-on** — A makes B easier but isn't strictly required
- **related** — A and B use similar thinking but neither depends on the other

### Links to Content

Every piece of content gets tagged with concept nodes:

```
{
  "lesson": "G5-M2-L4",
  "teaches": ["unit-form-multiplication", "mental-math-strategies"],
  "practices": ["distributive-property", "place-value"],
  "assumes": ["single-digit-multiplication", "arrays"],
  "problems": [
    {
      "id": "G5-M2-L4-PS-1",
      "type": "problem-set",
      "requires": ["unit-form-multiplication", "distributive-property"],
      "answer": "248",
      "answer_format": "number"
    }
  ]
}
```

## What This Enables

### 1. Test Question → Source Lessons

Student photographs a test problem. App identifies concept nodes required. Reverse lookup finds:
- The lesson(s) that originally taught each concept
- The homework that practiced it
- Similar problems from other lessons
- Duane Habecker's video for that specific lesson

### 2. "I'm Stuck" → Prerequisites

Student is stuck on a problem. App traverses backwards in the graph:
- What concepts does this problem require?
- Which of those concepts has the student demonstrated mastery of (from prior interactions)?
- Which prerequisite is likely missing?
- Jump to the lesson/practice for that prerequisite

### 3. Scaffolded Practice Generation

The graph defines the decomposition for the "more like this" feature:
- Problem requires concepts A + B + C
- Generate practice for A alone, B alone, A+B, then A+B+C
- The graph tells you exactly what A, B, and C are — no AI guessing needed

### 4. Cross-Grade Connections

The graph spans PK-12. A 5th grader struggling with multi-digit multiplication might have a gap in:
- 3rd grade: distributive property
- 2nd grade: array models
- 1st grade: place value

The graph traces the full dependency chain across years.

### 5. Parent Decoder

Parent photographs a problem. App identifies:
- Concept nodes involved (with human-readable names and aliases)
- Each strategy that can solve it (linked from the concept node)
- Which lessons taught each strategy (with page references)
- Duane Habecker video for that lesson

### 6. Spanish / Translation Layer

Concepts are language-independent. The graph structure is the same in any language. Only the labels, descriptions, and content text need translation. This means:
- Translate once at the node level, every content link inherits it
- A Spanish-speaking parent gets the same graph navigation in Spanish
- Bilingual households can mix languages

### 7. Teacher Dashboard (future)

If the app tracks student interactions:
- Which concept nodes has this student practiced?
- Where are the gaps in the graph?
- Class-level view: which concepts does the whole class struggle with?

## How to Build It

### Phase 1: Extract Concept Tags (AI + Structured Data)

Input: Aspose-parsed lesson content (objectives, vocabulary, teacher scripts, problem sets)

For each lesson, AI extracts:
1. **Concepts taught** — what new ideas are introduced in this lesson?
2. **Concepts practiced** — what prior knowledge is exercised?
3. **Concepts assumed** — what prerequisites does the teacher script reference? ("Remember when we learned..." = dependency signal)
4. **Vocabulary** — strategy names, mathematical terms
5. **Problem decomposition** — for each problem, which concepts are required to solve it?

Prompt pattern:
```
Given this Grade 5 Module 2 Lesson 4 content:
[lesson text]

Identify:
1. New concepts introduced in this lesson
2. Prior concepts referenced or assumed
3. For each problem in the Problem Set, list the concepts needed to solve it
4. Name any strategies taught (e.g., "area model", "unit form")

Use consistent concept names across lessons.
```

### Phase 2: Build the Graph

1. Deduplicate concept names across lessons (AI identifies that "unit form strategy" in L4 and "unit form" in L5 are the same concept)
2. Infer edges from the lesson progression — if concept B appears in a lesson that assumes concept A, add edge A → B
3. Validate against the scope and sequence documents (which describe the intended progression)
4. Cross-reference with CCSS standards (each standard maps to concept nodes)

### Phase 3: Validate with Humans

The teacher bounty system:
- Show teachers the extracted graph for their grade level
- Pay them to verify: are the dependencies correct? Are any missing?
- Particularly valuable for cross-grade edges (a 5th grade teacher may not know the 2nd grade prerequisite)

### Phase 4: Tag Problems

For every problem in every problem set, homework, and assessment:
1. AI reads the problem text and identifies concept nodes
2. AI identifies the expected answer and format (number, expression, diagram, etc.)
3. Store as structured data linked to the graph

## Scale Estimate

EngageNY grades 4-8:
- ~1,368 DOCX files
- Estimated ~600-800 individual lessons
- Each lesson has ~5-15 problems (problem set + homework + exit ticket)
- Estimated ~6,000-10,000 individual problems to tag
- Estimated ~200-400 unique concept nodes across grades 4-8
- Estimated ~500-1,000 edges

The AI extraction is a batch job — process each lesson once, review the output, refine. The graph grows as you process more lessons. Cross-grade edges emerge as the same concept names appear in different grades.

## The Moat

Anyone can host EngageNY content (it's CC BY-NC-SA). Nobody has:
1. The concept graph connecting all content
2. Machine-readable problem data with answers and concept tags
3. Cross-grade dependency chains
4. Cross-curriculum concept name mapping (aliases)
5. The combination of all four as structured, queryable data

This data layer is what makes every feature in the Paper Math Companion work. Without it, you have a camera app that shows solutions. With it, you have a tutor that understands what you know, what you don't, and what to do about it.
