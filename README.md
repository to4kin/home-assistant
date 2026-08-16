# Home Assistant Blueprints

Reusable Home Assistant automation blueprints and Zigbee2MQTT converters.

This public repository intentionally excludes the household Home Assistant configuration. The blueprint file paths remain stable because existing Home Assistant installations import them directly.

## Blueprints

### Automations

#### [Preheat Toggle Control](blueprints/automation/preheat-toogle-control.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fpreheat-toogle-control.yaml)

Manages a preheat toggle for on-the-way-home heating.

**Features:**

- Configurable safety timeout (default: 2 hours)
- Outside temperature threshold using a temperature sensor or weather entity (optional)
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
- Commands are queued and processed in arrival order
- Mobile notifications (optional)
- TTS confirmation (optional)
- Logbook entries (optional)

**Requires:** [Yandex Station](https://github.com/AlexxIT/YandexStation) integration (HACS).

---

#### [Z2M Device Offline Alert](blueprints/automation/z2m-device-offline-alert.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fz2m-device-offline-alert.yaml)

Monitors Zigbee2MQTT devices and sends one alert per offline device.

**Features:**

- Automatically groups Home Assistant entities by Zigbee2MQTT device
- Sends one alert per device, regardless of how many entities it exposes
- Sends one global bridge alert when Zigbee2MQTT itself is unavailable
- Device-level exclude and critical-device selectors
- Configurable normal and critical offline delays
- Quiet hours with critical-device and bridge bypass
- Optional repeat, persistent, and back-online notifications
- A zero repeat interval disables repeats

**Requires:** [Zigbee2MQTT](https://www.zigbee2mqtt.io/) with Home Assistant MQTT discovery enabled.

**Startup limitation:** A device that was already offline when the automation loaded will alert only after it produces a new availability transition. This avoids false alerts while MQTT discovery is still restoring entities after Home Assistant startup.

---

#### [Humidity Alert](blueprints/automation/humidity-alert.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity-alert.yaml)

Monitors humidity sensors and sends alerts when humidity exceeds threshold.

**Features:**

- Monitor multiple humidity sensors
- Room detection from sensor area/friendly name
- Configurable humidity threshold (default: 60%)
- Notifications use the current humidity and weather values after the configured delay
- Gradual humidity recovery is tracked across the hysteresis boundary
- Outside humidity/temperature/rain checks (optional)
- Presence awareness (optional)
- Time-based filtering (optional)
- Mobile notifications
- "Humidity normalized" notification (optional)
- TTS announcements (optional)
- Logbook entries (optional)

**Requires:** Assign humidity sensors to areas in Home Assistant for automatic room detection.

**Restart limitation:** Home Assistant or automation restart cancels a lifecycle that is waiting to send its normalized notification.

---

#### [Humidity Room Monitor](blueprints/automation/humidity-room-monitor.yaml)

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2Fto4kin%2Fhome-assistant%2Fblob%2Fmain%2Fblueprints%2Fautomation%2Fhumidity-room-monitor.yaml)

Per-room humidity monitoring with independent mould and condensation risk lifecycles.

**Features:**

- Sustained mould risk detection with configurable warning and danger thresholds
- Sustained condensation risk calculation from dew point and estimated window temperature
- Independent alert and recovery notifications for mould and condensation risks
- Configurable hysteresis to prevent notification flapping
- Room names derived from Home Assistant entity metadata
- Weather-aware recommendations
- Presence awareness (optional)
- Time-based filtering (optional)
- Mobile notifications
- TTS announcements (optional)
- Logbook entries (optional)

**Breaking change in 2.0:** Removed the room-name and dashboard-helper inputs. Existing automations must be deleted and recreated from the updated blueprint; no compatibility migration is provided.

**Restart limitation:** Home Assistant or automation restart resets in-progress alert delays and recovery waits. Runtime behavior should be verified in a compatible Home Assistant test instance.

## Zigbee2MQTT converters

### Aqara W500 floor-heating thermostat

The reusable external converter is available at [`zigbee2mqtt/external_converters/aqara_w500.mjs`](zigbee2mqtt/external_converters/aqara_w500.mjs).

## Development

Run validation and regression tests before submitting changes:

```bash
bash scripts/validate-public.sh
bash scripts/test.sh
```

Syntax checks do not replace testing behavior in a compatible Home Assistant instance.
