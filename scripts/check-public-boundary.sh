#!/usr/bin/env bash
set -euo pipefail

public_repo_root=$(git rev-parse --show-toplevel)
cd "$public_repo_root"

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

echo "Public repository boundary is valid"
