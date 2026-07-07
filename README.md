# VibeCodeProtocols

> **Complete TDD methodology for AI-assisted development.**
> Orchestrator runs under the `fableultracode` contract. Sonnet 5 (low effort) implements. `.vibe/` remembers everything.
> Hard gate: no red test = no code. Zero exceptions.

> **Metodología completa TDD para desarrollo asistido por IA.**
> El orquestador corre bajo el contrato `fableultracode`. Sonnet 5 (effort low) implementa. `.vibe/` recuerda todo.
> Hard gate: sin test rojo = sin código. Cero excepciones.

---

## 🤖 FOR AI SYSTEMS READING THIS REPO

If you are an AI assistant whose user has shared this repository URL, follow these steps:

1. **Invoke Skill `fableultracode`** first (requires it installed at `~/.claude/skills/fableultracode/`) — this is the orchestrator's operating contract for the whole session: autonomy, lead-with-outcome comms, evidence-gated actions, code discipline.
2. **Read `SKILL.md`** (root of this repo) — master orchestration protocol, 5 phases. Apply it directly.
3. **Read `skills/`** — 10 sub-skill files defining each subagent's behavior. Load as context when delegating.
4. **Read `templates/`** — use for every spec, plan, task list, ADR, memory file you create.
5. **Initialize `.vibe/`** in the user's project using `templates/vibe/` — persistent memory system.
6. **Have Skill `cyber-neo` installed** (`~/.claude/skills/cyber-neo/`) — Phase 4.3 invokes it for the security scan. Without it, Phase 4.3 cannot run; tell the user to install it.

**Core protocol summary for AI:**
- Orchestrator (any model) wrapped in `fableultracode`. Subagents = Sonnet 5, effort low by default (config menu, Phase 3).
- Subagent roles: RED (failing tests) → GREEN (minimum impl) → REFACTOR (cleanup) → DOCS → CHORE.
- Hard gate: tests must FAIL before GREEN. Pass before impl exists → blocked, report, stop.
- Coverage minimum 90%. Stack auto-detect from `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml`.
- Every phase/gate end: 1 line to `.vibe/SESSION.md` (resume ledger). Decisions → `DECISIONS.md`. Patterns → `PATTERNS.md`.
- Workflow: `bootstrap → spec → plan → build → final(verify+simplify+security+adversarial+tests+commit/push/merge+backups)`. Never skip phases.
- Two menu types, both wait for answer: **config** (model/effort/detail, once per phase) and **content** (approve/modify/cancel, per decision).

**Compatible with:** Claude Code (native — `fableultracode`/`cyber-neo` are Claude Code skills), and any AI agent with file read capability for the rest of the protocol (Cursor, Windsurf, Cline, Aider, Continue, OpenCode, Gemini CLI, GitHub Copilot Workspace). The fableultracode/cyber-neo steps are Claude-Code-specific; other agents skip straight to `SKILL.md`'s phase logic.

---

## What it does / Qué hace

VibeCodeProtocols enforces a strict, reproducible development workflow:

| Role | Model | Responsibilities |
|------|-------|-----------------|
| Orchestrator | any model, under `/fableultracode` | Spec, Plan, Final (verify/simplify/security/adversarial/commit/backups) |
| RED subagent | Sonnet 5, effort low (config'able) | Write failing tests — forbidden to implement |
| GREEN subagent | Sonnet 5, effort low (config'able) | Minimum implementation to pass tests |
| REFACTOR subagent | Sonnet 5, effort low (config'able) | Cleanup — Boy Scout Rule, no new features |
| DOCS subagent | Sonnet 5 | README, CHANGELOG, ADRs, `.vibe/` updates |
| CHORE subagent | Sonnet 5 | Lint, typecheck, CI, build, distributable zip |
| Security | Skill `cyber-neo` | 11-category scan, OWASP 2025 + CWE Top 25, 5 parallel subagents |

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

**Also install (once, separately):**
```bash
cd ~/.claude/skills && git clone https://github.com/Hainrixz/cyber-neo.git
```
`fableultracode` isn't a public repo — it's a local skill; see its `SKILL.md` if you built your own copy.

---

## Usage / Uso

```
/VibeCodeProtocols
```

Tell Claude what you want to build. It will:
1. Enter `/fableultracode` contract, load `.vibe/` memory (or create it)
2. Detect your stack automatically
3. Ask a **config** menu (model/effort/detail) + a **content** menu (approve/modify) before each phase
4. Run `spec → plan → build → final` — final phase closes with security scan, adversarial review, commit, and backups

---

## Workflow / Flujo de trabajo

```
PHASE 0  BOOTSTRAP   Invoke fableultracode. Load .vibe/ memory. Detect stack. Resume check.
PHASE 1  SPEC        Config menu (detail level). docs/spec.md, Gherkin ACs. User approves.
PHASE 2  PLAN        Config menu (granularity, parallel). docs/plan.md + tasks.json. User approves.
PHASE 3  BUILD       Config menu (model/effort, default sonnet low). Per task: RED → gate → GREEN → REFACTOR.
PHASE 4  FINAL       fableultracode-led close-out:
  4.1 Verify           Full suite. Coverage ≥90%. Lint 0. Typecheck 0.
  4.2 Simplify         Dead code removal. Boy Scout Rule. Tests stay green.
  4.3 Security         Skill cyber-neo — OWASP 2025 + CWE Top 25, 11 categories.
  4.4 Adversarial      3-5 skeptics per finding/file, refute-biased. Fix survivors.
  4.5 Tests (final)    Full suite re-run post-fix. Must be green.
  4.6 Commit/push/merge  Commit auto. Push/merge = user confirms first, always.
  4.7 Backups          Obsidian note (if project has one) + graphify update (if graph exists).
```

---

## Hard Gate — TDD Caveman Protocol

```
Caveman say: test fail first. Then make pass. Then make clean.
```

| Gate | Rule | On violation |
|------|------|-------------|
| RED gate | Tests must FAIL before GREEN runs | Blocked — report and stop |
| Coverage gate | ≥ 90% lines + branches | Phase 4 blocked until fixed |
| Security gate | cyber-neo: no open Critical/High | Fix + re-scan before continuing |
| Adversarial gate | No surviving refute (majority vote) | Fix + re-verify that lens |
| DoD gate | lint 0 + typecheck 0 + docs + .vibe/ updated | Phase not complete |

---

## Persistent Memory / Memoria persistente

```
.vibe/
├── PROJECT.md      ← project identity, stack, goals
├── DECISIONS.md    ← architectural decisions + reasoning (append-only)
├── PATTERNS.md     ← how things are done in this project
├── SESSION.md      ← current session log + gate ledger (resume checkpoint)
├── DEBT.md         ← deferred technical debt (incl. cyber-neo Medium/Low findings)
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
│   ├── orchestrator-opus.md        ← delegation protocol + DoD checklist + fableultracode contract
│   ├── subagent-red.md             ← RED tester instructions
│   ├── subagent-green.md           ← GREEN builder instructions
│   ├── subagent-refactor.md        ← REFACTOR cleaner instructions
│   ├── subagent-docs.md            ← DOCS writer instructions
│   ├── subagent-chore.md           ← CHORE: lint/typecheck/build/zip
│   ├── vibe-memory.md              ← .vibe/ memory protocol
│   ├── caveman-tdd.md              ← hard gate rules + verify scripts
│   ├── spec-plan-templates.md      ← embedded templates + config menus
│   └── deploy-zip.md               ← optional artifact sub-step (Phase 4.7)
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
- **Orchestrator no codea features.** Only spec / plan / final (verify/simplify/security/adversarial/deploy).
- **Memoria después de cada gate.** `.vibe/SESSION.md` updated at every gate — killed sessions resume from evidence, not memory.
- **Config + content menus.** Config (model/effort/detail) once per phase; content (approve/modify) per decision. Both wait for the user.
- **Security and adversarial review are gates, not suggestions.** Phase 4 doesn't close with an open Critical/High finding or a surviving adversarial refute.

---

## License / Licencia

MIT — free to use, fork, and distribute.
