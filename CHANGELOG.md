# Changelog

All notable changes to VibeCodeProtocols are documented here.
Format: [Keep a Changelog](https://keepachangelog.com) — Semantic Versioning.

---

## [Unreleased]

---

## [1.1.0] — 2026-07-07

### Changed
- **Orchestration model**: orchestrator now runs under the `fableultracode` skill contract (invoked Phase 0, session-long) instead of a bare Opus persona — autonomy, lead-with-outcome comms, evidence-gated actions, code discipline.
- **Phase count 7→5**: Bootstrap, Spec, Plan, Build, Final. Old TEST/SIMPLIFY/DEPLOY collapsed into one `Phase 4 — Final`, fableultracode-orchestrated.
- **Build model**: Sonnet 5, effort `low` by default (config menu, overridable per-task).
- **Config menus**: new phase-start config menu (model/effort/detail/granularity) added alongside the existing per-decision content menu.
- Rewrote `SKILL.md`, `skills/orchestrator-opus.md`, `skills/spec-plan-templates.md` for the new phase structure; net -227 lines (caveman-compressed, zero information loss).
- `skills/deploy-zip.md` scoped down to an optional Phase 4.7 artifact sub-step (build/zip/checksums/changelog/tag only — verify and commit moved to 4.1/4.6, no longer duplicated).

### Added
- **Phase 4.3 Security**: `cyber-neo` skill invocation — OWASP 2025 Top 10 + CWE Top 25, 11 categories, 5 parallel subagents. Critical/High blocks the phase; Medium/Low logs to `.vibe/DEBT.md`.
- **Phase 4.4 Adversarial review**: 3-5 independent skeptics per finding/file (correctness/security/reproduces lenses), refute-majority kills survivors — fableultracode pattern.
- **Phase 4.6 Commit/push/merge**: commit is automatic (reversible); push/merge always shown as an explicit command with user confirmation, never `--force`, never skip hooks.
- **Phase 4.7 Backups**: Obsidian `07_Backups_Log/` note (if the project has one) + `graphify update .` (if `graphify-out/` exists).
- `model_effort` field on `docs/tasks.json` tasks — carries the Phase 3 config choice per task.

---

## [1.0.0] — 2026-06-19

### Added
- Master skill `VibeCodeProtocols` — Opus orchestrator with full TDD workflow
- 5 Sonnet subagents: RED, GREEN, REFACTOR, DOCS, CHORE
- `.vibe/` memory system — plain Markdown, zero dependencies
- Hard gate: test failure verification before any implementation
- Coverage gate: 90% minimum (lines + branches)
- Stack auto-detection: TypeScript, Python, Go, Rust
- `install.sh` (bash) + `install.ps1` (PowerShell) installers
- `vibe-memory.sh` helper CLI
- `verify-red.sh` standalone RED gate verifier
- `build-zip.sh` distributable package builder
- Templates: spec.md, plan.md, tasks.json, adr.md, .vibe/* 
- Example feature: JWT authentication (spec + plan)
- Bilingüe: Spanish + English in all user-facing content
- Multiple-choice protocol: user confirms every significant decision
