# Home Assistant

My Home Assistant blueprints and configurations.

## Blueprints

### Automations

#### [Preheat Toggle Control](blueprints/automation/preheat-toogle-control.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fpreheat-toogle-control.yaml)

Manages a preheat toggle for on-the-way-home heating. Automatically disables preheat when someone arrives home, prevents activation while family members are present, and includes a configurable safety timeout.

**Features:**

- Auto-disable when family arrives home
- Block enabling if someone is already home
- Configurable arrival/leaving delays
- Auto-enable when everyone leaves (optional)
- Outside temperature threshold (summer mode)
- Mobile notifications
- Logbook entries

**Usage with AHC:** Add your preheat toggle to the [Advanced Heating Control](https://github.com/panhans/HomeAssistant/blob/main/blueprints/automation/panhans/advanced_heating_control.yaml) blueprint in the **Force Comfort/Eco Mode** → **🎈 Party mode** input.

---

#### [Yandex Station Voice Control](blueprints/automation/yandex-station-voice-control.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fyandex-station-voice-control.yaml)

Control any entity using voice commands from Yandex Station.

**Features:**

- Control any entity (switch, light, fan, cover, script, etc.)
- Multiple entities support
- Turn on, turn off, and toggle commands (all optional)
- Mobile notifications (optional)
- TTS confirmation via Yandex Station (optional)

**Requires:** [Yandex Station](https://github.com/AlexxIT/YandexStation) integration (HACS).
