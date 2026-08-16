#!/usr/bin/env bash
set -euo pipefail

public_repo_root=$(git rev-parse --show-toplevel)
cd "$public_repo_root"

while IFS= read -r -d '' tracked_path; do
  case "$tracked_path" in
    automations.yaml|configuration.yaml|dashboard.yaml|scripts.yaml|scenes.yaml|secrets.yaml|known_devices.yaml|groups.yaml|customize.yaml|docs/yandex-voice-commands.md|includes/*|packages/*|themes/*|www/*|.storage/*|.cloud/*|.HA_VERSION|.uuid|.ha_run.lock|deps/*|tts/*|backups/*|*.db|*.db-shm|*.db-wal|*.log|*.log.*|*.tar)
      echo "Public boundary violation: $tracked_path must not be tracked" >&2
      exit 1
      ;;
    zigbee2mqtt/*)
      case "$tracked_path" in
        zigbee2mqtt/external_converters/*) ;;
        *)
          echo "Public boundary violation: $tracked_path must not be tracked" >&2
          exit 1
          ;;
      esac
      ;;
  esac
done < <(git ls-files -z)

private_paths=(
  automations.yaml
  configuration.yaml
  dashboard.yaml
  scripts.yaml
  scenes.yaml
  secrets.yaml
  known_devices.yaml
  includes/packages/example.yaml
  themes/example.yaml
  docs/yandex-voice-commands.md
  .storage/core.config_entries
  home-assistant_v2.db
  home-assistant.log
  backups/example.tar
  zigbee2mqtt/configuration.yaml
  zigbee2mqtt/database.db
  zigbee2mqtt/log/current/log.txt
)

for private_path in "${private_paths[@]}"; do
  if ! git check-ignore -q --no-index "$private_path"; then
    echo "Public boundary violation: $private_path is not ignored" >&2
    exit 1
  fi
done

public_paths=(
  README.md
  AGENTS.md
  blueprints/automation/humidity-alert.yaml
  zigbee2mqtt/external_converters/aqara_w500.mjs
)

for public_path in "${public_paths[@]}"; do
  if git check-ignore -q --no-index "$public_path"; then
    echo "Public boundary violation: $public_path is ignored" >&2
    exit 1
  fi
done

if ! command -v grep >/dev/null 2>&1; then
  echo "Public boundary check requires grep" >&2
  exit 1
fi

credential_pattern='(password|api_key|access_token|refresh_token|client_secret):[[:space:]]+[^![:space:]]'
while IFS= read -r -d '' yaml_path; do
  if grep -q -i -E "$credential_pattern" "$yaml_path"; then
    echo "Potential literal credential found in public configuration; inspect $yaml_path locally" >&2
    exit 1
  fi
done < <(git ls-files -z --cached --others --exclude-standard -- '*.yaml' '*.yml')

echo "Public repository boundary is valid"
