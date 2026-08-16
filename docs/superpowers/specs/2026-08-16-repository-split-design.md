# Repository Split Design

## Goal

Keep this repository public and focused on reusable Home Assistant blueprints while moving the complete household-specific Home Assistant configuration into a separate private repository.

The split must preserve all existing blueprint import URLs and avoid exposing credentials or private household details.

## Current State

The committed history contains only the public project files: the README, `.gitignore`, and automation blueprints. The household configuration files currently present in the working tree are untracked and have never been committed, so no Git history rewrite is required.

The repository currently has no project-level agent instructions, automated validation, or Home Assistant configuration checks. Basic parsing confirms that the current YAML and Zigbee converter JavaScript are syntactically valid, but it does not validate Home Assistant semantics.

## Repository Boundaries

### Public blueprint repository

This existing repository remains at its current GitHub location so that installed blueprints continue to update from their existing `source_url` values.

It contains:

- reusable automation blueprints under `blueprints/automation/`;
- documentation for public blueprints;
- the reusable Aqara W500 Zigbee2MQTT converter under `zigbee2mqtt/external_converters/`;
- `AGENTS.md` with repository-specific development and validation rules;
- lightweight validation configuration and CI.

It must not contain:

- live `configuration.yaml`, `automations.yaml`, `scripts.yaml`, scenes, dashboards, packages, or themes from the household instance;
- household-specific entity IDs, person names, network details, coordinates, credentials, tokens, logs, databases, or backups;
- generated Home Assistant runtime state.

Existing blueprint filenames, including `preheat-toogle-control.yaml`, remain unchanged because renaming them would break established import URLs. A future compatibility-preserving rename would require keeping the old path as a supported forwarding copy.

### Private configuration repository

A separate private repository, provisionally named `home-assistant-config`, contains the configuration required to reproduce the household Home Assistant instance.

It may contain:

- `configuration.yaml`, automations, scripts, scenes, dashboards, packages, and themes;
- household-specific entity IDs and automation behavior;
- Zigbee2MQTT configuration and private device customizations;
- its own `AGENTS.md`, validation scripts, and documentation.

It must still exclude secrets, databases, logs, backups, caches, and sensitive Home Assistant runtime storage. Credentials, tokens, coordinates, and externally reachable addresses are referenced through `!secret`. A tracked `secrets.example.yaml` documents required secret keys without real values.

## Blueprint Integration

The repositories remain independent; no Git submodule or copied blueprint source is introduced.

Home Assistant continues to install and update public blueprints through their existing public URLs. Automations in the private repository may reference imported blueprint paths such as `to4kin/<blueprint>.yaml`, but the private repository does not become another source of truth for those blueprints.

This avoids duplicated code and keeps normal Home Assistant blueprint import behavior unchanged.

## Migration Sequence

1. Protect the public repository with a comprehensive `.gitignore` and public-scope `AGENTS.md`.
2. Create the private repository with its own safe ignore rules and agent instructions.
3. Copy the household configuration into the private repository without deleting the original local files.
4. Replace sensitive literals with `!secret` references and add `secrets.example.yaml`.
5. Validate the private configuration and confirm that it contains everything required by its includes.
6. Commit and back up the private repository.
7. Only after explicit user confirmation, remove the household configuration files from the public working tree.

The migration uses copy-before-cleanup semantics so that configuration is never lost during the split.

## Public Repository Improvements

The first implementation pass should be deliberately small:

- add `AGENTS.md` describing repository scope, sensitive-data rules, file conventions, compatibility requirements, and validation commands;
- update `.gitignore` to block common live Home Assistant configuration and runtime files;
- update the README to clarify that this is a public blueprint repository;
- add YAML syntax validation and JavaScript syntax validation for the converter;
- document the distinction between syntax checks and full Home Assistant semantic validation.

Blueprint behavior fixes should be handled in separate, testable commits after the repository boundary is protected. The audit already identified candidates requiring targeted verification, including zero-duration repeat notifications and humidity normalization transitions.

## Private Repository Instructions

The private repository's `AGENTS.md` should require agents to:

- read the complete Home Assistant include graph before changing configuration;
- never print, add, or replace real secret values;
- preserve UI-generated IDs and existing entity references unless a migration is planned;
- distinguish public reusable components from household-specific configuration;
- run syntax checks and a Home Assistant configuration check before claiming completion;
- avoid deleting configuration or runtime data without explicit confirmation and a verified backup.

## Validation

### Public repository

- parse every YAML file while accepting Home Assistant tags such as `!input`;
- check the Zigbee2MQTT converter with `node --check`;
- run whitespace/error checks with `git diff --check`;
- validate blueprint semantics with Home Assistant tooling when a reproducible local or containerized check is available.

### Private repository

- parse all YAML includes;
- verify that every referenced include exists;
- verify that every `!secret` key has a corresponding entry in the local untracked `secrets.yaml`;
- run the Home Assistant configuration checker against the target Home Assistant version;
- review staged files for credentials and unexpected runtime artifacts before every commit.

## Failure Handling

If the private repository cannot be created or validated, the household files remain untouched in the current working tree. If a sensitive value is discovered in committed history, migration pauses and the history-cleanup procedure is designed separately before any push.

No cleanup operation is part of the initial implementation without explicit user confirmation.

## Success Criteria

- existing public blueprint URLs continue to work;
- the public repository contains no household-specific configuration or sensitive data;
- the private repository contains a validated Home Assistant configuration that is restorable once the separately stored secrets are supplied;
- both repositories have focused `AGENTS.md` guidance;
- automated checks catch malformed YAML and JavaScript before merge;
- no local configuration is deleted until the private copy is committed and verified.
