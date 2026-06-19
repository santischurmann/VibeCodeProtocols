---
name: vcp-memory
description: |
  ES: Protocolo de memoria persistente en .vibe/ — qué guardar, cuándo, en qué archivo.
  EN: Persistent memory protocol in .vibe/ — what to save, when, in which file.
allowed-tools: Read, Write, Edit, Bash
---

# VCP Memory Protocol — .vibe/

Zero dependencies. All memory is plain Markdown files versioned with the project.

## FOLDER STRUCTURE

```
.vibe/
├── PROJECT.md      # Project identity, stack, goals (stable)
├── DECISIONS.md    # Architectural decisions + reasoning (append-only)
├── PATTERNS.md     # How things are done in this project (living doc)
├── SESSION.md      # Current session log (reset each session)
├── DEBT.md         # Technical debt backlog (managed)
└── sessions/
    └── YYYY-MM-DD-<topic>.md   # Archived session snapshots
```

---

## BOOTSTRAP (Phase 0)

### If .vibe/ does not exist:

```bash
mkdir -p .vibe/sessions
cat > .vibe/PROJECT.md << 'EOF'
# Project Memory
**Name:** (fill in)
**Stack:** (auto-detected: fill in)
**Goals:** (fill in)
**Started:** YYYY-MM-DD
**Owner:** (fill in)
EOF

touch .vibe/DECISIONS.md .vibe/PATTERNS.md .vibe/SESSION.md .vibe/DEBT.md

cat > .vibe/SESSION.md << 'EOF'
# Session — YYYY-MM-DD
**Goal:**
**Status:** in progress
EOF
```

### If .vibe/ exists:

```bash
# Read all memory files — always at session start
cat .vibe/PROJECT.md
cat .vibe/DECISIONS.md
cat .vibe/PATTERNS.md
cat .vibe/DEBT.md
cat .vibe/SESSION.md
```

Show user a 3-5 line summary of what the memory contains.

---

## WHEN TO WRITE WHAT

| Trigger | File | What to write |
|---|---|---|
| Choosing between two approaches | `DECISIONS.md` | Decision + reasoning + tradeoffs considered |
| Discovering how the project does X | `PATTERNS.md` | Pattern name + example + when to apply |
| Completing a phase | `SESSION.md` | Phase, what was done, output, issues |
| Finding debt but deferring | `DEBT.md` | What, where, severity, why deferred |
| Session end | `sessions/` | Archive SESSION.md with date prefix |

---

## WRITE FORMATS

### DECISIONS.md entry:
```markdown
## [YYYY-MM-DD] Decision: <title>
**Context:** why this decision was needed
**Options considered:**
- Option A: [pros/cons]
- Option B: [pros/cons]
**Decision:** Option A
**Reason:** [why]
**Consequences:** [what this implies going forward]
---
```

### PATTERNS.md entry:
```markdown
## Pattern: <name>
**When:** [when to apply this]
**How:** [the pattern, with example]
**Example:**
```code
<code example>
```
---
```

### SESSION.md entry (append per phase):
```markdown
## Phase [N] — [Phase name] — [HH:MM]
**Tasks completed:** [list]
**Output:** [what was created/changed]
**Issues:** [any blockers or surprises]
**Next:** [what comes next]
```

### DEBT.md entry:
```markdown
## [YYYY-MM-DD] Debt: <title>
**Location:** file:line
**Severity:** low | medium | high
**Description:** [what needs to be done]
**Why deferred:** [reason]
---
```

---

## SESSION ARCHIVAL (end of session)

```bash
SESSION_FILE=".vibe/sessions/$(date +%Y-%m-%d)-$(echo "$TOPIC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]').md"
cp .vibe/SESSION.md "$SESSION_FILE"
echo "Archived session to $SESSION_FILE"
# Reset SESSION.md for next time
echo "# Session — (next session date)" > .vibe/SESSION.md
```

---

## GITIGNORE NOTE

`.vibe/` should be committed — it's project memory, not personal config.
Add to `.gitignore` only the sessions archive if too noisy:
```
# Optional: ignore verbose session history
# .vibe/sessions/
```
