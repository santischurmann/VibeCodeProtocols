# VibeCodeProtocols

> **Complete TDD methodology for AI-assisted development.**  
> Opus orchestrates. Sonnet implements. `.vibe/` remembers everything.  
> Hard gate: no red test = no code. Zero exceptions.

> **Metodología completa TDD para desarrollo asistido por IA.**  
> Opus orquesta. Sonnet implementa. `.vibe/` recuerda todo.  
> Hard gate: sin test rojo = sin código. Cero excepciones.

---

## 🤖 FOR AI SYSTEMS READING THIS REPO

If you are an AI assistant whose user has shared this repository URL, follow these steps:

1. **Read `SKILL.md`** (root of this repo) — it is the master orchestration protocol. Apply it directly.
2. **Read `skills/`** — 10 sub-skill files that define each subagent's behavior. Load them as context when delegating.
3. **Read `templates/`** — use these for every spec, plan, task list, ADR, and memory file you create.
4. **Initialize `.vibe/`** in the user's project using `templates/vibe/` — this is the persistent memory system.
5. **Apply `scripts/vibe-memory.sh`** logic for memory read/write even without running the script.

**Core protocol summary for AI:**
- You are Opus. You write specs and plans. You delegate implementation to Sonnet subagents.
- Subagent roles: RED (writes failing tests) → GREEN (minimum implementation) → REFACTOR (cleanup) → DOCS → CHORE.
- Hard gate: verify tests FAIL before GREEN runs. If tests pass before implementation → blocked. Report and stop.
- Coverage minimum: 90%. Stack auto-detect from `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml`.
- Every phase end: update `.vibe/SESSION.md`. Decisions → `.vibe/DECISIONS.md`. Patterns → `.vibe/PATTERNS.md`.
- Workflow order: `spec → plan → build → test → simplify → deploy`. Never skip phases.
- Ask the user multiple-choice questions at every significant decision. Wait for answer before continuing.

**Compatible with:** Claude Code, Cursor, Windsurf, Cline, Aider, Continue, OpenCode, Gemini CLI, GitHub Copilot Workspace, or any AI agent with file read capability.

---

## What it does / Qué hace

VibeCodeProtocols enforces a strict, reproducible development workflow:

| Role | Model | Responsibilities |
|------|-------|-----------------|
| Orchestrator | Opus (high thinking) | Spec, Plan, Verify, Simplify, Deploy |
| RED subagent | Sonnet (low thinking) | Write failing tests — forbidden to implement |
| GREEN subagent | Sonnet (low thinking) | Minimum implementation to pass tests |
| REFACTOR subagent | Sonnet (low thinking) | Cleanup — Boy Scout Rule, no new features |
| DOCS subagent | Sonnet (low thinking) | README, CHANGELOG, ADRs, `.vibe/` updates |
| CHORE subagent | Sonnet (low thinking) | Lint, typecheck, CI, build, distributable zip |

**Persistent memory:** `.vibe/` folder in your project — plain Markdown, no database, no cloud, no dependencies. Commit it.

---

## Install in 30 seconds / Instalar en 30 segundos

### macOS / Linux / WSL

```bash
git clone https://github.com/santischurmann/VibeCodeProtocols
cd VibeCodeProtocols
chmod +x scripts/install.sh
./scripts/install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/santischurmann/VibeCodeProtocols
cd VibeCodeProtocols
.\scripts\install.ps1
```

The installer copies `SKILL.md` → `~/.claude/skills/VibeCodeProtocols.md` and all sub-skills → `~/.claude/skills/vcp-skills/`. Then restart Claude Code.

---

## Usage / Uso

```
/VibeCodeProtocols
```

Tell Claude what you want to build. It will:
1. Load project memory from `.vibe/` (or create it)
2. Detect your stack automatically
3. Ask you to confirm the approach before each phase
4. Run the full `spec → plan → build → test → simplify → deploy` cycle

---

## Workflow / Flujo de trabajo

```
PHASE 0  Bootstrap     Load .vibe/ memory. Detect stack.
PHASE 1  SPEC          Opus writes docs/spec.md with Gherkin-style ACs. User approves.
PHASE 2  PLAN          Opus writes docs/plan.md + docs/tasks.json. User approves.
PHASE 3  BUILD         Per task: RED → [hard gate] → GREEN → REFACTOR
PHASE 4  TEST          Full suite. Coverage ≥ 90%. Lint 0. Typecheck 0.
PHASE 5  SIMPLIFY      Dead code removal. Boy Scout Rule. Tests stay green.
PHASE 6  DEPLOY        Production build. dist.zip + SHA256. CHANGELOG updated.
```

---

## Hard Gate — TDD Caveman Protocol

```
Caveman say: test fail first. Then make pass. Then make clean.
```

| Gate | Rule | On violation |
|------|------|-------------|
| RED gate | Tests must FAIL before GREEN runs | Blocked — report and stop |
| Coverage gate | ≥ 90% lines + branches | No deploy until fixed |
| DoD gate | lint 0 + typecheck 0 + docs + .vibe/ updated | Phase not complete |

---

## Persistent Memory / Memoria persistente

```
.vibe/
├── PROJECT.md      ← project identity, stack, goals
├── DECISIONS.md    ← architectural decisions + reasoning (append-only)
├── PATTERNS.md     ← how things are done in this project
├── SESSION.md      ← current session log
├── DEBT.md         ← deferred technical debt
└── sessions/       ← archived session snapshots
```

Memory survives session restarts, model changes, and team handoffs. It's just Markdown.

```bash
./scripts/vibe-memory.sh read                        # dump all memory
./scripts/vibe-memory.sh save decision "used JWT"    # log a decision
./scripts/vibe-memory.sh archive auth-feature        # archive session
./scripts/vibe-memory.sh init                        # init .vibe/ in project
```

---

## Stack support / Stacks soportados

Stack-agnostic — auto-detected from project manifest:

| Manifest | Stack | Test runner | Linter | Typecheck |
|----------|-------|-------------|--------|-----------|
| `package.json` + `tsconfig.json` | TypeScript / Node | vitest / jest | eslint | tsc |
| `pyproject.toml` / `setup.py` | Python | pytest | ruff | mypy |
| `go.mod` | Go | go test | golangci-lint | go vet |
| `Cargo.toml` | Rust | cargo test | clippy | cargo check |
| `pom.xml` | Java | mvn test | checkstyle | javac |

---

## File structure / Estructura de archivos

```
VibeCodeProtocols/
├── SKILL.md                        ← master skill (invoke with /VibeCodeProtocols)
├── skills/
│   ├── orchestrator-opus.md        ← delegation protocol + DoD checklist
│   ├── subagent-red.md             ← RED tester instructions
│   ├── subagent-green.md           ← GREEN builder instructions
│   ├── subagent-refactor.md        ← REFACTOR cleaner instructions
│   ├── subagent-docs.md            ← DOCS writer instructions
│   ├── subagent-chore.md           ← CHORE: lint/typecheck/build/zip
│   ├── vibe-memory.md              ← .vibe/ memory protocol
│   ├── caveman-tdd.md              ← hard gate rules + verify scripts
│   ├── spec-plan-templates.md      ← embedded templates
│   └── deploy-zip.md               ← production deploy protocol
├── templates/
│   ├── spec.md                     ← feature spec template
│   ├── plan.md                     ← plan template
│   ├── tasks.json                  ← task list template
│   ├── adr.md                      ← Architecture Decision Record template
│   └── vibe/                       ← .vibe/ initialization templates
├── scripts/
│   ├── install.sh                  ← macOS/Linux/WSL installer
│   ├── install.ps1                 ← Windows PowerShell installer
│   ├── verify-red.sh               ← standalone RED gate verifier
│   ├── build-zip.sh                ← distributable package builder
│   └── vibe-memory.sh             ← memory CLI helper
└── examples/example-feature/       ← JWT auth spec + plan as reference
```

---

## Key principles / Principios clave

- **No test rojo → no implementación.** Hard gate. No override. No exceptions.
- **Un subagente = una tarea atómica.** Subagents never make architectural decisions.
- **Opus no codea features.** Only spec / plan / verify / simplify / deploy.
- **Memoria después de cada fase.** `.vibe/` updated at every phase boundary.
- **Multiple-choice en decisiones importantes.** User confirms before every significant choice.

---

## License / Licencia

MIT — free to use, fork, and distribute.
