#!/usr/bin/env bash
set -euo pipefail

public_repo_root=$(git rev-parse --show-toplevel)
cd "$public_repo_root"

bash scripts/check-public-boundary.sh

git ls-files -z -- '*.yaml' '*.yml' | xargs -0 ruby -ryaml -e '
  ARGV.each do |file|
    YAML.parse_file(file)
    puts "YAML OK: #{file}"
  end
'

while IFS= read -r -d '' converter_file; do
  node --check "$converter_file"
  echo "JavaScript OK: $converter_file"
done < <(find zigbee2mqtt/external_converters -type f -name '*.mjs' -print0)

git diff --check
echo "Public repository validation passed"
