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
- Source station filtering (listen to specific stations only)
- Per-action delays (separate delay for on/off/toggle)
- Mobile notifications with custom title and messages
- TTS confirmation via Yandex Station (optional)
- Optional logbook entries

**Requires:** [Yandex Station](https://github.com/AlexxIT/YandexStation) integration (HACS).

---

#### [Z2M Device Offline Alert](blueprints/automation/z2m-device-offline-alert.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fz2m-device-offline-alert.yaml)

Monitors Zigbee2MQTT devices and sends notifications when they go offline.

**Features:**

- Monitors all Z2M devices automatically
- Exclude specific devices from monitoring
- Critical devices with shorter delay (bypass quiet hours)
- Time-based filtering (quiet hours)
- Repeat notifications for still-offline devices
- Configurable delay before alerting (default: 30 minutes)
- Mobile and persistent notifications
- Optional back online notification
- Optional logbook entries

**Requires:** [Zigbee2MQTT](https://www.zigbee2mqtt.io/) integration.
