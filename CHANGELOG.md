# Changelog

## v0.1.1 — 2026-09-30

### Changed

- Made the auditor explicitly local-only and offline.
- Removed remote-fetch behavior from the audit workflow.
- Disabled interactive Git credential prompting.
- Clarified that upstream comparisons use locally cached remote-tracking refs.
- Changed repository findings to informational results rather than process failures.
- Added validation guards against accidental network or mutating Git operations.
- Expanded documentation around safety and status semantics.

### Safety

The default auditor performs no repository mutations and no network operations.

## v0.1.0 — 2026-09-30

### Added

- Initial multi-repository Git state scanner.
- Working-tree state reporting.
- Branch/upstream reporting.
- Stash detection.
- Latest commit reporting.
- Markdown report generation.
- Validation/archive workflow.
