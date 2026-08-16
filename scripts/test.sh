#!/usr/bin/env bash
set -euo pipefail

public_repo_root=$(git rev-parse --show-toplevel)
cd "$public_repo_root"

tests_found=false

while IFS= read -r -d '' test_file; do
  tests_found=true
  ruby "$test_file"
done < <(find tests -type f -name '*_test.rb' -print0)

if [[ "$tests_found" == false ]]; then
  echo "No Ruby tests found" >&2
  exit 1
fi

echo "Ruby tests passed"
