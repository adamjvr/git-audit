# Safety Model

## Core rule

`git-audit` observes local repository state and does not take corrective action.

Repository mutation and network activity are separate decisions that belong to the user.

## Prohibited behavior

The auditor must not automatically execute operations such as:

```text
git fetch
git pull
git push
git commit
git checkout
git switch
git stash
git reset
git merge
git rebase
git remote add
git remote set-url
git remote remove
```

It must not repair authentication, rewrite remotes, create or delete branches, clean files, or synchronize repositories.

## Network policy

The runtime audit is offline by design.

Configured remote URLs and remote-tracking refs may be read because they are local metadata. Neither action contacts a remote.

## Cached upstream semantics

`LOCAL COMMITS NOT IN CACHED UPSTREAM` compares local `HEAD` with the locally stored upstream tracking ref. It does not prove those commits are absent from GitHub.

`CACHED UPSTREAM AHEAD` likewise refers only to the locally stored tracking ref.

## Non-interactive execution

Git subprocesses run with interactive credential prompting disabled.

The audit should never stop to ask for GitHub usernames, passwords, tokens, SSH credentials, or credential-manager interaction.

## Findings are not failures

A dirty working tree, stash, missing remote, detached HEAD, or cached branch difference is reported for review and does not make the audit command itself fail.

## Future changes

Any future feature capable of contacting a remote or mutating a repository should remain outside the default audit path and must not silently weaken this safety contract.
