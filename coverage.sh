#!/usr/bin/env bash
set -eu
# Enable pipefail when supported (bash/zsh); avoids error under POSIX sh
if [ -n "${BASH_VERSION-}" ] || [ -n "${ZSH_VERSION-}" ]; then
  set -o pipefail
fi

# Simple coverage helper for this project
# - Cleans previous luacov artifacts
# - Runs specs
# - Prints detailed and summarized coverage reports

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
COV_DIR="$ROOT_DIR/coverage"

mkdir -p "$COV_DIR"

# Remove old artifacts (both legacy root files and files inside coverage dir)
rm -f "$ROOT_DIR/luacov.report.out" \
      "$ROOT_DIR/luacov.report.out.index" \
      "$ROOT_DIR/luacov.stats.out"

rm -f "$COV_DIR/luacov.report.out" \
      "$COV_DIR/luacov.report.out.index" \
      "$COV_DIR/luacov.stats.out"

# Run tests with busted collecting coverage
# Optional first arg filters which test files to run (Lua pattern match on filenames)
# Examples:
#   ./coverage.sh              # run all tests (default)
#   ./coverage.sh utils        # run tests whose filename contains "utils"
#   ./coverage.sh routines     # run tests whose filename contains "routines"
# You can invoke with either `./coverage.sh <filter>` or `sh coverage.sh <filter>`

if [ $# -gt 0 ] && [ -n "${1-}" ]; then
  # Build a safe Lua pattern that matches any filename containing the given fragment
  # and ending with _spec.lua (same convention used in this repo)
  # Note: we escape percent for Lua pattern and anchor to end of name for precision
  FILTER="$1"
  PATTERN=".*${FILTER}.*_spec%.lua$"
  busted tests -c --pattern "$PATTERN"
else
  busted tests -c
fi

# Show full report filtered to tests dir, then summary
luacov-console tests
luacov-console -s tests
