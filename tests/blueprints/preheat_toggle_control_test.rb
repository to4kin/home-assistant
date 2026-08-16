# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)
BLUEPRINT_PATH = File.join(ROOT, "blueprints/automation/preheat-toogle-control.yaml")
README_PATH = File.join(ROOT, "README.md")

class PreheatToggleControlTest < Minitest::Test
  INPUTS = %w[
    preheat_toggle timeout_duration input_outside_temperature
    input_outside_temperature_threshold input_persons input_arrival_delay
    input_auto_enable_on_leave input_leaving_delay notify_devices notify_title
    enable_logbook
  ].freeze

  def setup
    @blueprint = File.read(BLUEPRINT_PATH)
    @readme = File.read(README_PATH)
  end

  def test_keeps_public_contract
    assert_includes @blueprint, "**Version**: 1.3.1"
    assert_includes @blueprint, 'min_version: "2025.1.0"'
    assert_includes @blueprint, "preheat-toogle-control.yaml"
    INPUTS.each { |input| assert_match(/^        #{input}:$/, @blueprint) }
  end

  def test_reads_weather_temperature_attribute_and_rejects_non_numeric_values
    assert_includes @blueprint, "input_outside_temp_domain"
    assert_includes @blueprint, "state_attr(input_outside_temp, 'temperature')"
    assert_includes @blueprint, "is_number(outside_temp_raw)"
    assert_match(/input_outside_temp_domain\s*==\s*'weather'/, @blueprint)
    assert_match(/outside_temperature\s+is not none.*outside_temp_threshold/m, @blueprint)
    assert_operator @blueprint.scan("{{ outside_temperature }}°C").length, :>=, 2
  end

  def test_readme_mentions_weather_temperature_support
    section = @readme[/#### \[Preheat Toggle Control\].*?(?=\n---\n|\z)/m]
    refute_nil section
    assert_includes section, "weather entity"
  end
end
