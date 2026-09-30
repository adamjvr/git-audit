# git-audit

Read-only audit tool for checking the backup/commit state of a directory full of Git repositories.

## What it checks

For every repository it finds:

- working tree cleanliness
- staged files
- modified files
- untracked files
- merge conflicts
- configured remotes
- configured upstream branch
- local commits ahead of upstream
- local branch behind upstream
- detached HEAD state
- Git stashes
- latest commit
- optional remote refresh with `git fetch --all --prune`

The tool **does not commit, push, pull, checkout, stash, reset, or modify repositories**.

## Usage

Audit `~/GitHub` using locally cached remote state:

```bash
./git-audit ~/GitHub
```

Refresh remotes first:

```bash
./git-audit ~/GitHub --fetch
```

Create a Markdown report:

```bash
./git-audit ~/GitHub \
  --fetch \
  --markdown ~/Downloads/github-repo-audit.md
```

## Status meanings

- `SAFE` — clean working tree and synchronized configured upstream
- `NEEDS COMMIT` — staged, modified, or untracked files exist
- `NEEDS PUSH` — local commits have not reached the configured upstream
- `BEHIND` — upstream has commits not present locally
- `NO REMOTE` — repository has no configured remote
- `NO UPSTREAM` — current branch does not track a remote branch
- `STASHED WORK` — one or more Git stashes exist
- `DETACHED` — repository is in detached HEAD state
- `FETCH FAILED` — remote refresh failed
- `CONFLICTS` — unresolved merge conflicts exist

Multiple conditions may be shown together.

## Validation

```bash
./scripts/build_test.sh
```

Validation evidence is emitted as one timestamped ZIP in `~/Downloads`.

`scripts/check.sh` is retained as a compatibility wrapper.
