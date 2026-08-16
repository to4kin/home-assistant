# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)
BLUEPRINT_PATH = File.join(ROOT, "blueprints/automation/z2m-device-offline-alert.yaml")
README_PATH = File.join(ROOT, "README.md")

class Z2mDeviceOfflineAlertTest < Minitest::Test
  def setup
    @blueprint = File.read(BLUEPRINT_PATH)
    @readme = File.read(README_PATH)
  end

  def test_breaking_device_level_contract
    assert_includes @blueprint, "**Version**: 2.0.0"
    assert_match(/exclude_devices:.*?selector:\n\s+device:/m, @blueprint)
    assert_match(/critical_devices:.*?selector:\n\s+device:/m, @blueprint)
    refute_includes @blueprint, "exclude_entities:"
    refute_includes @blueprint, "critical_entities:"
  end

  def test_uses_zigbee2mqtt_device_registry_identity
    assert_includes @blueprint, "device_id(event_entity_id)"
    assert_includes @blueprint, "device_entities(event_device_id)"
    assert_includes @blueprint, "zigbee2mqtt_"
    assert_includes @blueprint, "zigbee2mqtt_bridge_"
    assert_includes @blueprint, "via_device_id"
  end

  def test_deduplicates_overlapping_entity_transitions
    assert_includes @blueprint, "event_new_last_changed"
    assert_includes @blueprint, "latest_invalid_entity_id"
    assert_match(/delay:\n\s+seconds: 1/, @blueprint)
    assert_match(/latest_invalid_entity_id\s*==\s*event_entity_id/, @blueprint)
  end

  def test_invalid_state_change_hands_off_the_offline_lifecycle
    assert_includes @blueprint, "event_state_changed"
    assert_match(
      /offline_candidate:.*?not event_new_available.*?event_state_changed/m,
      @blueprint
    )
  end

  def test_bridge_outage_suppresses_child_alerts
    assert_includes @blueprint, "is_bridge"
    assert_includes @blueprint, "bridge_device_id"
    assert_includes @blueprint, "bridge_is_available"
    assert_match(/is_bridge\s+or\s+bridge_is_available/, @blueprint)
  end

  def test_zero_repeat_interval_is_guarded
    assert_includes @blueprint, "repeat_seconds"
    assert_match(/repeat_seconds\s*>\s*0/, @blueprint)
    refute_match(/while:.*?delay:\s*!input repeat_notification/m, @blueprint)
  end

  def test_recovery_cleanup_is_device_level
    assert_includes @blueprint, "online_cleanup_candidate"
    assert_includes @blueprint, "persistent_notification.dismiss"
    assert_includes @blueprint, "z2m_offline_{{ event_device_id }}"
  end

  def test_readme_describes_device_and_bridge_level_behavior
    section = @readme[/#### \[Z2M Device Offline Alert\].*?(?=\n---\n|\z)/m]

    refute_nil section
    assert_includes section, "one alert per device"
    assert_includes section, "bridge"
    assert_includes section, "already offline"
  end
end
