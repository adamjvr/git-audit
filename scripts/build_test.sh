#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${HOME}/Downloads/git-audit-BuildTest-${STAMP}"
ZIP="${OUT}.zip"
PASS=1

mkdir -p "$OUT"

{
  echo "git-audit local-only validation"
  echo "timestamp: $(date --iso-8601=seconds)"
  echo "repo: $ROOT"
  echo

  echo "== Python syntax =="
  if python3 -m py_compile "$ROOT/git-audit"; then
    echo "PASS"
  else
    echo "FAIL"
    PASS=0
  fi

  echo
  echo "== Help smoke test =="
  if "$ROOT/git-audit" --help; then
    echo "PASS"
  else
    echo "FAIL"
    PASS=0
  fi

  echo
  echo "== Verify forbidden network/mutation options are absent =="
  HELP="$("$ROOT/git-audit" --help 2>&1)"
  FORBIDDEN=0
  for word in fetch push pull commit checkout stash reset fix; do
    if printf '%s\n' "$HELP" | grep -Eq -- "--${word}([[:space:]=]|$)"; then
      echo "FAIL: unexpected option --$word"
      FORBIDDEN=1
    fi
  done

  if [[ "$FORBIDDEN" -eq 0 ]]; then
    echo "PASS"
  else
    PASS=0
  fi

  echo
  echo "== Local state smoke test =="
  TMP="$(mktemp -d)"
  mkdir -p "$TMP/repos"
  git init -q "$TMP/repos/test-repo"
  git -C "$TMP/repos/test-repo" config user.name "git-audit test"
  git -C "$TMP/repos/test-repo" config user.email "test@example.invalid"
  printf 'hello\n' > "$TMP/repos/test-repo/README.md"
  git -C "$TMP/repos/test-repo" add README.md
  git -C "$TMP/repos/test-repo" commit -qm "Initial test commit"
  printf 'working tree change\n' >> "$TMP/repos/test-repo/README.md"

  if "$ROOT/git-audit" "$TMP/repos"; then
    echo "PASS"
  else
    echo "FAIL"
    PASS=0
  fi

  rm -rf "$TMP"

  echo
  echo "== Source guard: reject explicit network/mutation subprocesses =="
  if grep -En 'run_git\([^)]*"(fetch|push|pull|commit|checkout|reset|merge|rebase|remote[[:space:]]+(add|set-url|remove))"' "$ROOT/git-audit"; then
    echo "FAIL: mutating/network Git command found"
    PASS=0
  else
    echo "PASS"
  fi

  echo
  echo "== Git status =="
  git -C "$ROOT" status --short --branch || true
} > "$OUT/validation.txt" 2>&1

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$ROOT/git-audit" > "$OUT/git-audit.sha256"
fi

(
  cd "$(dirname "$OUT")"
  zip -qr "$ZIP" "$(basename "$OUT")"
)

rm -rf "$OUT"

echo "Validation archive:"
echo "  $ZIP"

if [[ "$PASS" -eq 1 ]]; then
  echo "PASS"
  exit 0
else
  echo "FAIL"
  exit 1
fi
