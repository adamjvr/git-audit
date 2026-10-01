# Status Reference

`git-audit` may combine several conditions for one repository.

## `CLEAN LOCAL STATE`

No locally detectable review conditions were found. This does **not** mean GitHub was contacted or verified.

## `UNCOMMITTED WORK`

One or more staged, modified, or untracked files exist.

## `CONFLICTS`

Git reports unresolved conflict entries.

## `NO REMOTE`

The repository has no configured Git remote.

## `NO UPSTREAM`

The current branch does not have an upstream tracking branch configured.

## `LOCAL COMMITS NOT IN CACHED UPSTREAM`

Local `HEAD` is ahead of the locally cached upstream tracking reference. No fetch is performed.

## `CACHED UPSTREAM AHEAD`

The locally cached upstream tracking reference is ahead of local `HEAD`. No fetch is performed.

## `DETACHED`

The repository is currently in detached HEAD state.

## `STASHED WORK`

One or more Git stashes are present. The auditor does not inspect, apply, drop, or modify them.

## Review queue

Any repository not reported as `CLEAN LOCAL STATE` appears in the review queue.

The queue is deliberately not a repair queue.
