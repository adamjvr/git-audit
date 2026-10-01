# git-audit

`git-audit` is a deliberately hands-off auditor for directories containing many local Git repositories.

Its purpose is simple: show you what is sitting on disk so **you** can decide what, if anything, needs attention.

## Safety contract

`git-audit` is diagnostic only.

It does **not** fetch, push, pull, commit, checkout, switch branches, stash, reset, merge, rebase, change remotes, contact GitHub, or automatically repair repositories.

All Git subprocesses are run non-interactively.

See [`docs/SAFETY.md`](docs/SAFETY.md) for the full safety model.

## What it reports

For each repository, `git-audit` reports:

- clean vs. uncommitted working tree
- staged files
- modified files
- untracked files
- unresolved conflicts
- current branch
- detached HEAD state
- configured remotes
- configured upstream branch
- local comparison with the **cached** upstream reference
- Git stashes
- latest local commit
- local repository path

Because the tool never fetches, an upstream comparison is intentionally limited to whatever remote-tracking reference already exists locally. It does **not** claim to know the current state of GitHub.

## Requirements

- Python 3
- Git

No Python packages are required.

## Usage

```bash
./git-audit ~/GitHub
```

Generate a Markdown report:

```bash
./git-audit ~/GitHub \
  --markdown ~/Downloads/github-repo-audit.md
```

Repository findings are informational and do not cause a non-zero exit code.

## Example interpretation

```text
State:     UNCOMMITTED WORK + LOCAL COMMITS NOT IN CACHED UPSTREAM
Changes:   modified:2, untracked:1
Upstream:  local +3 / cached upstream +0
```

This means local files have uncommitted changes and local `HEAD` is three commits ahead of the machine's cached upstream ref. **No network verification was performed.**

See [`docs/STATUS_REFERENCE.md`](docs/STATUS_REFERENCE.md) for status meanings.

## Validation

```bash
./scripts/build_test.sh
```

Validation evidence is written as one timestamped archive:

```text
~/Downloads/git-audit-BuildTest-YYYYMMDD-HHMMSS.zip
```

No loose validation logs are left behind.

`scripts/check.sh` remains a compatibility wrapper.

## Project philosophy

This project intentionally favors **observation over automation**.

Its job is:

> Tell me what is here. Touch nothing.

## Version

Current documented behavior: **v0.1.1 — Local-only diagnostic mode**

See [`CHANGELOG.md`](CHANGELOG.md).
