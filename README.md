# Home Assistant

My Home Assistant blueprints and configurations.

## Blueprints

### Automations

#### [Preheat Toggle Control](blueprints/automation/preheat-toogle-control.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fpreheat-toogle-control.yaml)

Manages a preheat toggle for on-the-way-home heating.

**Features:**

- Configurable safety timeout (default: 2 hours)
- Outside temperature threshold, summer mode (optional)
- Auto-disable when family arrives home
- Block enabling if someone is already home
- Configurable arrival/leaving delays (default: 30 seconds)
- Auto-enable when everyone leaves (optional)
- Mobile notifications (optional)
- Logbook entries (optional)

**Requires:** Create an `input_boolean` helper for the preheat toggle.

**Usage with AHC:** Add your preheat toggle to the [Advanced Heating Control](https://github.com/panhans/HomeAssistant/blob/main/blueprints/automation/panhans/advanced_heating_control.yaml) blueprint in the **Force Comfort/Eco Mode** → **🎈 Party mode** input.

---

#### [Yandex Station Voice Control](blueprints/automation/yandex-station-voice-control.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fyandex-station-voice-control.yaml)

Control any entity using voice commands from Yandex Station.

**Features:**

- Control any entity (switch, light, fan, cover, script, etc.)
- Multiple entities support
- Source station filtering (optional)
- Turn on, turn off, and toggle commands (optional)
- Per-action delays (optional)
- Mobile notifications (optional)
- TTS confirmation (optional)
- Logbook entries (optional)

**Requires:** [Yandex Station](https://github.com/AlexxIT/YandexStation) integration (HACS).

---

#### [Z2M Device Offline Alert](blueprints/automation/z2m-device-offline-alert.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fz2m-device-offline-alert.yaml)

Monitors Zigbee2MQTT devices and sends notifications when they go offline.

**Features:**

- Monitors all Z2M devices automatically
- Configurable delay before alerting (default: 30 minutes)
- Exclude specific devices from monitoring (optional)
- Critical devices with shorter delay, bypass quiet hours (optional)
- Time-based filtering (optional)
- Mobile notifications
- Repeat notifications for still-offline devices (optional)
- Persistent notifications (optional)
- Back online notification (optional)
- Logbook entries (optional)

**Requires:** [Zigbee2MQTT](https://www.zigbee2mqtt.io/) integration.

---

#### [Humidity Alert](blueprints/automation/humidity-alert.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity-alert.yaml)

Monitors humidity sensors and sends alerts when humidity exceeds threshold.

**Features:**

- Monitor multiple humidity sensors
- Room detection from sensor area/friendly name
- Configurable humidity threshold (default: 60%)
- Outside humidity/temperature/rain checks (optional)
- Presence awareness (optional)
- Time-based filtering (optional)
- Mobile notifications
- "Humidity normalized" notification (optional)
- TTS announcements (optional)
- Logbook entries (optional)

**Requires:** Assign humidity sensors to areas in Home Assistant for automatic room detection.

---

#### [Humidity Room Monitor](blueprints/automation/humidity-room-monitor.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity-room-monitor.yaml)

Per-room humidity monitoring with mould and condensation risk calculation.

**Features:**

- Monitor one room's humidity and temperature
- Mould risk detection (warning/danger thresholds)
- Condensation risk calculation (dew point vs window temperature)
- Configurable notification level (Warning or Danger)
- Update helpers for dashboard display (optional)
- Weather-aware recommendations
- Presence awareness (optional)
- Time-based filtering (optional)
- Mobile notifications
- TTS announcements (optional)
- Logbook entries (optional)

**Requires:** Create one automation per room. Optionally create `input_text` helpers for mould/condensation risk status.
