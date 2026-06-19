# Changelog

All notable changes to VibeCodeProtocols are documented here.
Format: [Keep a Changelog](https://keepachangelog.com) — Semantic Versioning.

---

## [Unreleased]

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
