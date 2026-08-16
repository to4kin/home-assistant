#!/usr/bin/env bash
set -euo pipefail

public_repo_root=$(git rev-parse --show-toplevel)
cd "$public_repo_root"

tests_found=false

while IFS= read -r -d '' test_file; do
  tests_found=true

  github_group_open=false
  if [[ "${GITHUB_ACTIONS:-false}" == true ]]; then
    echo "::group::Test: $test_file"
    github_group_open=true
  fi

  echo "Running: $test_file"
  if ruby "$test_file" --verbose; then
    test_status=0
  else
    test_status=$?
  fi

  if [[ "$github_group_open" == true ]]; then
    echo "::endgroup::"
  fi

  if ((test_status != 0)); then
    exit "$test_status"
  fi
done < <(find tests -type f -name '*_test.rb' -print0)

if [[ "$tests_found" == false ]]; then
  echo "No Ruby tests found" >&2
  exit 1
fi

echo "Ruby tests passed"
