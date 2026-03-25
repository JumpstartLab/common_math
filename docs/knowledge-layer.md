# Knowledge Layer: Structured Graph + Vector Intelligence

## Two Layers, One Brain

### Layer 1: Structured Concept Graph (the skeleton)

Deterministic, exact, fast. Handles everything that needs to be reliable:

- Lesson → concept → prerequisite navigation
- Answer checking against known problem data
- Scaffolding sequences via dependency traversal
- "Show me all lessons that teach X" — exact lookup
- "What do I need to know before Y" — graph traversal
- Progress tracking — which nodes has this student demonstrated mastery of?

Data: ~300 nodes, ~800 edges, ~8,000 tagged problems. Stored in a relational database (Postgres) or document store. Tiny. Queryable in milliseconds.

### Layer 2: Vector + LLM Intelligence (the intuition)

Fuzzy, natural language, associative. Handles everything where the user doesn't know the right terminology:

- "I don't get why you break the number apart" → finds "distributive property" concept
- Photo of an unknown problem → finds similar problems/concepts by content similarity
- "What's that thing where you draw boxes" → surfaces "area model multiplication"
- "What should I review before Module 3" → synthesizes answer from graph + embeddings
- Cross-curriculum matching: enVision vocabulary → EngageNY equivalents

Data: vector embeddings of all content. Stored in a vector database. Also tiny.

## What Gets Embedded

### Content Chunks

Each chunk is a meaningful unit of curriculum content, embedded as a vector:

| Chunk Type | Count (est.) | Avg Tokens | Example |
|---|---|---|---|
| Lesson objectives | ~700 | ~50 | "Convert numerical expressions into unit form as a mental strategy for multi-digit multiplication" |
| Lesson teacher scripts | ~700 | ~2,000 | The full T:/S: dialogue for a lesson |
| Problem text + solution | ~8,000 | ~100 | "8 × 31 = ? Using unit form: 31 eights = 30 eights + 1 eight = 248" |
| Concept node descriptions | ~300 | ~100 | "Area model multiplication: using rectangular area to represent multiplication of two factors" |
| Strategy explanations | ~50 | ~200 | "Partial products: decompose one factor by place value, multiply each part, then add" |
| Vocabulary definitions | ~200 | ~30 | "Minuend: the number being subtracted from" |
| Section/topic overviews | ~150 | ~300 | Module and topic overview text |

**Total: ~10,000 chunks, ~3-4M tokens to embed**

### Embedding Cost Estimate

Using OpenAI text-embedding-3-small ($0.02 per 1M tokens):
- 4M tokens × $0.02/1M = **$0.08 total**
- Literally eight cents to embed the entire grades 4-8 curriculum

Using text-embedding-3-large ($0.13 per 1M tokens):
- 4M tokens × $0.13/1M = **$0.52 total**

Re-embedding after updates is equally cheap. This is a non-cost.

### Metadata on Each Vector

Every embedded chunk carries metadata for filtering and linking back to the structured graph:

```json
{
  "chunk_id": "G5-M2-L4-teacher-script",
  "type": "teacher_script",
  "grade": 5,
  "module": 2,
  "lesson": 4,
  "topic": "B",
  "concept_nodes": ["unit-form-multiplication", "distributive-property"],
  "language": "en",
  "standards": ["5.NBT.5", "5.NBT.6"]
}
```

This means vector search results immediately connect back to the structured graph. You find a fuzzy match, then use the concept_nodes to traverse the graph for precise navigation.

## Query Patterns

### Pattern 1: Student Types a Question

```
Student: "I don't understand how to break apart 49 × 20"

→ Embed query
→ Vector search finds similar content (top 5)
  1. G5-M2-L7 teacher script (discusses decomposing 49 into 50-1)
  2. Concept: "unit-form-multiplication" description
  3. G5-M2-L4 problem "49 × 20"
  4. Strategy: "decomposition-near-friendly-numbers"
  5. G5-M2-L3 teacher script (introduces the strategy)

→ Extract concept nodes from results: [unit-form-multiplication, decomposition]
→ Graph lookup: prerequisites, related lessons, practice problems
→ Return: "This uses the unit form strategy. You're thinking of 49 as
   50 - 1, so 49 × 20 = (50 × 20) - (1 × 20). This was introduced in
   Lesson 3. Want to practice with some simpler problems first?"
```

### Pattern 2: Camera Input — Unknown Problem

```
Student photographs a problem from a different textbook:
"Use the distributive property to find 35 × 12"

→ OCR extracts text
→ Embed problem text
→ Vector search finds similar problems in our database
  1. G5-M2-L4-PS-3: "49 × 20" (same strategy, different numbers)
  2. G5-M2-L5-HW-2: "35 × 14" (very similar)
  3. G5-M2-L3-PS-1: "12 × 31" (same structure)

→ Concept nodes: [distributive-property, multi-digit-multiplication]
→ Graph: these concepts taught in Lessons 3-5
→ Return: strategy walkthrough + reference to relevant lessons
```

### Pattern 3: Parent Natural Language

```
Parent: "What's the thing where they draw boxes to multiply?"

→ Embed query
→ Vector search finds:
  1. Strategy: "area-model" description
  2. Concept: "area-model-multiplication"
  3. G4-M3-L2 teacher script (introduces area models)

→ Return: "That's called the area model (also called box
   multiplication). It was introduced in Grade 4, Module 3.
   Here's how it works: [strategy explanation]. Your child's
   textbook covers this on page 42."
```

### Pattern 4: Cross-Curriculum Matching

```
Teacher using enVision: "My textbook calls it 'partial products'
but the practice problems use a different format"

→ Embed "partial products multiplication format"
→ Vector search spans concept aliases and descriptions
→ Finds: concept node "partial-products" with aliases including
  "partial products" (enVision), "area model written form" (Eureka)

→ Graph: shows all lessons teaching partial products
→ Return: "In Eureka Math, this is most closely covered in
   Grade 4 Module 3 Topics C-D. The approach is similar but
   Eureka uses the term 'area model written form'."
```

### Pattern 5: "What Should I Review Before..."

```
Teacher: "What should my students know before starting Module 3?"

→ Embed query + extract "Grade 5 Module 3" context
→ LLM reads Module 3 overview + first lesson objectives
→ Graph: find all concept nodes tagged as "assumes" in Module 3 lessons
→ Vector search: find any gaps between Module 2 content and Module 3 prereqs
→ LLM synthesizes: "Module 3 assumes fluency with multi-digit multiplication
   (Module 2) and decimal place value (Module 1). Key prerequisites:
   [list with lesson references]. If your students struggled with
   Lessons 7-9 in Module 2, consider reviewing before starting."
```

## Architecture

```
┌──────────────────────────────────────────────┐
│                User Query                     │
│  (typed text, photographed problem, voice)    │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│              Query Router                     │
│  • Exact match? → Graph lookup (fast)         │
│  • Known problem? → Answer check (fast)       │
│  • Natural language? → Vector search          │
│  • Complex question? → LLM + both layers      │
└────────┬─────────────────────┬───────────────┘
         │                     │
         ▼                     ▼
┌─────────────────┐  ┌─────────────────────────┐
│ Structured Graph │  │    Vector Database       │
│   (Postgres)     │  │  (Pinecone / pgvector)   │
│                  │  │                          │
│ • Concept nodes  │  │ • Lesson embeddings      │
│ • Dependency     │  │ • Problem embeddings     │
│   edges          │  │ • Concept embeddings     │
│ • Problem data   │  │ • Strategy embeddings    │
│ • Answer keys    │  │                          │
│ • Lesson links   │  │ 10K vectors              │
│ • Standards      │  │ ~50MB storage            │
│   crosswalk      │  │                          │
└────────┬─────────┘  └───────────┬─────────────┘
         │                        │
         └───────────┬────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────┐
│              LLM Synthesis                    │
│  (Claude API / GPT-4)                         │
│                                              │
│  Inputs:                                     │
│  • Graph context (relevant nodes + edges)     │
│  • Vector results (similar content chunks)    │
│  • User query + conversation history          │
│  • Student's concept mastery state            │
│                                              │
│  Outputs:                                    │
│  • Natural language explanation               │
│  • Specific lesson/page references            │
│  • Scaffolded practice sequence               │
│  • Strategy walkthrough                       │
│  • Socratic guiding questions                 │
└──────────────────────────────────────────────┘
```

### Query Router Logic

Not every query needs the LLM. The router saves cost and latency:

| Query Type | Route | Latency | Cost |
|---|---|---|---|
| "What's the answer to 8 × 31?" | Graph → answer key lookup | <50ms | $0 |
| "Show me Lesson 4 problems" | Graph → content lookup | <50ms | $0 |
| "What concepts does Lesson 4 teach?" | Graph → node lookup | <50ms | $0 |
| "I don't get breaking numbers apart" | Vector → top results → concept nodes | ~200ms | ~$0.001 |
| "Help me solve this step by step" | Vector + Graph + LLM synthesis | ~2s | ~$0.01-0.05 |
| "What should I review before Module 3?" | Graph traversal + LLM synthesis | ~3s | ~$0.02-0.10 |

Most queries hit the graph only. The vector layer handles fuzzy matching. The LLM only fires for synthesis/explanation — the expensive queries. At $0.05 per complex query, a heavy user doing 20 complex queries per session costs $1. At $8-12/month subscription, that's plenty of margin.

## Storage and Hosting

| Component | Size | Service | Cost |
|---|---|---|---|
| Structured content (HTML) | ~500 MB | S3 / Cloudflare R2 | ~$0.01/mo |
| Concept graph (Postgres) | <10 MB | Supabase free tier / Railway | $0-5/mo |
| Vector embeddings | ~50 MB | Supabase pgvector / Pinecone free | $0/mo |
| Images (CDN) | ~300 MB | Cloudflare R2 + CDN | ~$0.01/mo |
| **Total storage** | **<1 GB** | | **<$5/mo** |

The infrastructure cost is negligible. The per-query LLM cost is the real variable, and it's bounded by the subscription price.

## Spanish Layer Integration

Both layers support Spanish naturally:

**Structured graph:** Add `name_es`, `description_es`, `aliases_es` fields to every concept node. The graph structure (edges, dependencies) is identical — math concepts don't change in translation. Problems need translated text but the answer and concept tags stay the same.

**Vector layer:** Embed Spanish content alongside English. Multilingual embedding models (like OpenAI's) handle both languages in the same vector space — a Spanish query finds English content and vice versa. This means a partially-translated corpus still works: if a lesson hasn't been translated yet, a Spanish query still finds the English version as a fallback.

**Translation workflow:**
1. AI translates all concept node labels + descriptions (small, high-value, review once)
2. AI translates lesson text and problems (larger, batch process, teacher review via bounty)
3. Embed Spanish versions alongside English in the vector database
4. UI language toggle — same graph, different labels

## Build Sequence

1. **Embed existing content** — take the Aspose-parsed lessons, chunk them, embed. One afternoon of work, $0.52 in API costs.
2. **Stand up pgvector** — add the vector extension to whatever Postgres instance hosts the structured data. Zero additional infrastructure.
3. **Build the query router** — simple logic: exact match → graph, fuzzy → vector, complex → LLM. API endpoint that the web app and mobile app both call.
4. **AI concept extraction** — feed lessons to LLM, build the structured graph. Validate with scope & sequence docs.
5. **Connect the layers** — vector results return concept node IDs, which the graph uses for navigation.
6. **Spanish translation** — start with concept labels (small, high-impact), expand to full content.
