# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)
BLUEPRINT_PATH = File.join(ROOT, "blueprints/automation/humidity-alert.yaml")
README_PATH = File.join(ROOT, "README.md")

class HumidityAlertTest < Minitest::Test
  INPUTS = %w[
    humidity_sensors humidity_threshold humidity_threshold_duration
    humidity_hysteresis weather_entity outside_humidity_sensor
    outside_temp_sensor min_outside_temp check_rain presence_entities
    enable_time_filter time_start time_end notify_devices notify_title
    notify_message notify_message_weather notify_normalized
    notify_message_normalized enable_tts tts_target tts_message enable_logbook
  ].freeze

  def setup
    @blueprint = File.read(BLUEPRINT_PATH)
    @readme = File.read(README_PATH)
  end

  def test_keeps_public_contract
    assert_includes @blueprint, "**Version**: 1.2.0"
    assert_includes @blueprint, 'min_version: "2025.1.0"'
    INPUTS.each { |input| assert_match(/^        #{input}:$/, @blueprint) }
  end

  def test_requires_numeric_threshold_crossing
    assert_includes @blueprint, "old_humidity_is_numeric"
    assert_includes @blueprint, "new_humidity_is_numeric"
    assert_includes @blueprint, "is_number(trigger.from_state.state)"
    assert_includes @blueprint, "is_number(trigger.to_state.state)"
    assert_match(/crossed_threshold:.*old_humidity_is_numeric.*new_humidity_is_numeric/m, @blueprint)
  end

  def test_renders_messages_from_fresh_action_snapshots
    assert_includes @blueprint, "alert_humidity_state"
    assert_includes @blueprint, "alert_humidity"
    assert_includes @blueprint, "alert_notify_msg: !input notify_message"
    assert_includes @blueprint, "recovery_humidity"
    assert_includes @blueprint, "recovery_notify_msg: !input notify_message_normalized"
  end

  def test_waits_for_hysteresis_recovery
    assert_includes @blueprint, "wait_template:"
    assert_match(/humidity_threshold\s*-\s*humidity_hysteresis/, @blueprint)
    refute_includes @blueprint, "is_normalized:"
  end

  def test_allows_multiple_open_sensor_lifecycles
    assert_match(/^mode: parallel$/, @blueprint)
    assert_match(/^max: 50$/, @blueprint)
  end

  def test_readme_describes_current_values_and_lifecycle_recovery
    section = @readme[/#### \[Humidity Alert\].*?(?=\n---\n|\z)/m]
    refute_nil section
    assert_includes section, "current humidity"
    assert_includes section, "hysteresis"
    assert_includes section, "restart"
  end
end
