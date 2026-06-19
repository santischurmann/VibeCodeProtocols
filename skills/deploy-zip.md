---
name: vcp-deploy
description: |
  ES: Protocolo de deploy en producción: build optimizado, dist.zip con checksums, release notes, CHANGELOG.
  EN: Production deploy protocol: optimized build, dist.zip with checksums, release notes, CHANGELOG update.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# VCP Deploy Protocol

**Precondition:** ALL of the following must be true before running deploy:
- [ ] Full test suite passing (unit + integration + e2e)
- [ ] Coverage ≥ 90%
- [ ] Lint: 0 errors
- [ ] Typecheck: 0 errors
- [ ] SIMPLIFY phase complete

If any check fails → stop. Do NOT deploy broken code.

---

## STEP 1 — Final verification

```bash
# Run full suite one last time
<test_command> 2>&1
<lint_command> 2>&1
<typecheck_command> 2>&1
echo "Pre-deploy checks: DONE"
```

---

## STEP 2 — Determine version

Read current version from project manifest:

```bash
# Node
node -e "console.log(require('./package.json').version)"

# Python
grep -m1 "^version" pyproject.toml | cut -d'"' -f2

# Go
cat go.mod | head -3
```

Ask orchestrator / user for next version:

```
🔵 VERSION BUMP
Current version: X.Y.Z
A) Patch (X.Y.Z+1) — bug fixes only
B) Minor (X.Y+1.0) — new features, backward-compatible
C) Major (X+1.0.0) — breaking changes
```

Update version in manifest after user answers.

---

## STEP 3 — Production build

```bash
# Auto-detected from stack:
# Node/TS
npm run build 2>&1

# Python
python -m build --wheel 2>&1

# Go
mkdir -p dist
go build -o dist/<binary-name> ./cmd/... 2>&1

# Rust
cargo build --release 2>&1
cp target/release/<binary> dist/
```

Build must succeed with 0 errors. Verify artifacts exist in `dist/`.

---

## STEP 4 — Generate dist.zip

```bash
VERSION=$(cat .vibe/SESSION.md | grep "Version:" | tail -1 | awk '{print $2}')
ZIP_NAME="dist-${VERSION:-$(date +%Y%m%d)}.zip"

# Clean previous
rm -f dist.zip checksums.txt

# Create zip (exclude source maps, caches, test artifacts)
zip -r "$ZIP_NAME" dist/ \
  --exclude "*.map" \
  --exclude "**/__pycache__/**" \
  --exclude "**/.pytest_cache/**" \
  --exclude "**/node_modules/**" \
  --exclude "**/*.test.*" \
  --exclude "**/*.spec.*"

# Generate checksums
sha256sum "$ZIP_NAME" > checksums.txt
md5sum "$ZIP_NAME" >> checksums.txt

echo "=== ARTIFACT ==="
echo "File: $ZIP_NAME"
echo "Size: $(du -sh "$ZIP_NAME" | cut -f1)"
echo "SHA256: $(cat checksums.txt | head -1 | awk '{print $1}')"
```

---

## STEP 5 — Generate release notes from .vibe/SESSION.md

```bash
echo "## Release v${VERSION} — $(date +%Y-%m-%d)" > release-notes.md
echo "" >> release-notes.md
echo "### Changes" >> release-notes.md

# Extract SESSION.md phase completions
grep "^## Task\|^## Phase\|^- " .vibe/SESSION.md | head -30 >> release-notes.md

echo "" >> release-notes.md
echo "### Checksums" >> release-notes.md
cat checksums.txt >> release-notes.md
```

---

## STEP 6 — Update CHANGELOG.md

Move content from `## [Unreleased]` section to new versioned section:

```markdown
## [X.Y.Z] — YYYY-MM-DD

### Added
- ...

### Changed
- ...

### Fixed
- ...
```

Add new empty `## [Unreleased]` section at top.

---

## STEP 7 — Commit and tag

```bash
git add -A
git commit -m "release: v${VERSION}"
git tag -a "v${VERSION}" -m "Release v${VERSION}"
echo "Tagged: v${VERSION}"
echo "Run 'git push && git push --tags' to publish"
```

Do NOT push automatically. Show user the command. Ask for confirmation.

---

## STEP 8 — Archive session

```bash
SESSION_ARCHIVE=".vibe/sessions/$(date +%Y-%m-%d)-release-v${VERSION}.md"
cp .vibe/SESSION.md "$SESSION_ARCHIVE"
echo "# Session — (next)" > .vibe/SESSION.md
echo "Session archived to $SESSION_ARCHIVE"
```

---

## DEPLOY REPORT

```
DEPLOY COMPLETE — v<version>
Artifact:     <zip_name> (<size>)
SHA256:       <hash>
Tag:          v<version> (local, not pushed)
CHANGELOG:    updated
.vibe/:       session archived

To publish:
  git push && git push --tags

One-liner install (if distributing):
  curl -fsSL <your-raw-url>/install.sh | bash
```
