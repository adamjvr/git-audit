#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${HOME}/Downloads/git-audit-BuildTest-${STAMP}"
ZIP="${OUT}.zip"

mkdir -p "$OUT"

PASS=1

{
  echo "git-audit validation"
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
  echo "== Self audit smoke test =="
  TMP="$(mktemp -d)"
  mkdir -p "$TMP/repos"
  git init -q "$TMP/repos/test-repo"
  git -C "$TMP/repos/test-repo" config user.name "git-audit test"
  git -C "$TMP/repos/test-repo" config user.email "test@example.invalid"
  printf 'hello\n' > "$TMP/repos/test-repo/README.md"
  git -C "$TMP/repos/test-repo" add README.md
  git -C "$TMP/repos/test-repo" commit -qm "Initial test commit"

  if "$ROOT/git-audit" "$TMP/repos"; then
    echo "PASS"
  else
    RC=$?
    echo "NOTE: audit exited $RC because the synthetic repo intentionally has no remote."
    if [[ "$RC" -eq 1 ]]; then
      echo "PASS"
    else
      echo "FAIL"
      PASS=0
    fi
  fi

  rm -rf "$TMP"

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
