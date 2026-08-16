# AGENTS.md

## Repository purpose

This is a public repository for reusable Home Assistant automation blueprints and reusable Zigbee2MQTT converters. It is not the household Home Assistant configuration repository.

## Before making changes

1. Read `CLAUDE.md` in the repository root if it exists.
2. Read the complete file being changed and its README section.
3. Check `git status --short` and preserve unrelated user changes.
4. Never inspect ignored household files unless the user explicitly places them in scope.

## Privacy boundary

Do not add live Home Assistant configuration, dashboards, automations, scripts, scenes, packages, themes, secrets, runtime state, person names, household entity IDs, network details, coordinates, logs, databases, or backups.

Reusable examples must use generic entity IDs and documentation-only network ranges. Credentials and tokens must never appear, even as examples.

Run `bash scripts/check-public-boundary.sh` after changing `.gitignore` or repository layout.

## Blueprint compatibility

- Keep existing blueprint paths and `source_url` values stable because Home Assistant installations import them directly.
- Do not rename `preheat-toogle-control.yaml`; the misspelling is part of its published URL.
- Keep `blueprint.homeassistant.min_version` accurate.
- Do not hard-code household entity IDs, device IDs, notification targets, areas, or service names.
- Preserve input names unless the change includes a backward-compatible migration.
- Update the embedded blueprint version and the matching README description when behavior changes.

## File conventions

- Public blueprints belong in `blueprints/automation/`.
- Public blueprint documentation belongs in `README.md` or non-household files under `docs/`.
- Reusable Zigbee2MQTT converters belong in `zigbee2mqtt/external_converters/`.
- Keep YAML at two-space indentation and JavaScript consistent with the existing converter style.
- Prefer focused behavioral changes over unrelated formatting rewrites.

## Validation

Run all available checks before reporting completion:

```bash
bash scripts/check-public-boundary.sh
bash scripts/validate-public.sh
git diff --check
```

These checks validate syntax and repository boundaries. They do not prove Home Assistant runtime behavior; behavioral blueprint changes also require validation in a compatible Home Assistant test instance.

## Git operations

Do not stage, commit, push, rewrite history, or create a pull request unless the user explicitly requests it.
