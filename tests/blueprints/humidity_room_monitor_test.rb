# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)
BLUEPRINT_PATH = File.join(ROOT, "blueprints/automation/humidity-room-monitor.yaml")
README_PATH = File.join(ROOT, "README.md")

class HumidityRoomMonitorTest < Minitest::Test
  INPUTS = %w[
    humidity_sensor temperature_sensor weather_entity mould_warning_threshold
    mould_danger_threshold notify_level mould_hysteresis window_temp_offset
    condensation_warning_margin condensation_hysteresis min_outside_temp
    alert_delay presence_entities enable_time_filter time_start time_end
    notify_devices notify_title notify_message_mould
    notify_message_condensation notify_message_weather notify_normalized
    notify_message_normalized enable_tts tts_target tts_message_mould
    tts_message_condensation enable_logbook
  ].freeze

  def setup
    @blueprint = File.read(BLUEPRINT_PATH)
    @readme = File.read(README_PATH)
  end

  def test_defines_breaking_2_contract
    assert_includes @blueprint, "**Version**: 2.0.0"
    assert_includes @blueprint, 'min_version: "2025.1.0"'
    INPUTS.each { |input| assert_match(/^        #{input}:$/, @blueprint) }
    refute_match(/^        room:$/, @blueprint)
    refute_includes @blueprint, "mould_risk_helper:"
    refute_includes @blueprint, "condensation_risk_helper:"
  end

  def test_uses_two_sustained_risk_triggers
    assert_equal 2, @blueprint.scan(/platform: template/).length
    assert_equal 2, @blueprint.scan(/for: !input alert_delay/).length
    assert_includes @blueprint, "id: mould_risk"
    assert_includes @blueprint, "id: condensation_risk"
  end

  def test_requires_numeric_risk_inputs_without_fake_defaults
    assert_includes @blueprint, "is_number(states(humidity_sensor))"
    assert_includes @blueprint, "is_number(states(temperature_sensor))"
    assert_includes @blueprint, "is_number(state_attr(weather_entity, 'temperature'))"
    refute_includes @blueprint, "float(20)"
    refute_includes @blueprint, "float(10)"
    refute_includes @blueprint, "float(50)"
    refute_includes @blueprint, "current_humidity > 0"
  end

  def test_has_independent_hysteresis_recovery_and_native_time_conditions
    assert_match(/mould_threshold\s*-\s*mould_hysteresis/, @blueprint)
    assert_match(/condensation_warning_margin\s*\+\s*condensation_hysteresis/, @blueprint)
    assert_includes @blueprint, "condition: time"
    refute_includes @blueprint, "now().strftime"
    assert_includes @blueprint, '"humidity_room_mould_'
    assert_includes @blueprint, '"humidity_room_condensation_'
  end

  def test_runs_risks_in_parallel
    assert_match(/^mode: parallel$/, @blueprint)
    assert_match(/^max: 4$/, @blueprint)
  end

  def test_readme_describes_recreation_and_two_risks
    section = @readme[/#### \[Humidity Room Monitor\].*?(?=\n---\n|\z)/m]
    refute_nil section
    assert_includes section, "recreate"
    assert_includes section, "mould"
    assert_includes section, "condensation"
    assert_includes section, "restart"
  end
end
