# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)
BLUEPRINT_PATH = File.join(ROOT, "blueprints/automation/yandex-station-voice-control.yaml")
README_PATH = File.join(ROOT, "README.md")

class YandexStationVoiceControlTest < Minitest::Test
  INPUTS = %w[
    target_entities source_stations turn_on_command turn_on_delay
    turn_off_command turn_off_delay toggle_command toggle_delay notify_devices
    notify_title notify_message_on notify_message_off notify_message_toggle
    tts_entity tts_confirm_on tts_confirm_off tts_confirm_toggle enable_logbook
  ].freeze

  def setup
    @blueprint = File.read(BLUEPRINT_PATH)
    @readme = File.read(README_PATH)
  end

  def test_keeps_public_contract
    assert_includes @blueprint, "**Version**: 1.2.2"
    assert_includes @blueprint, 'min_version: "2025.1.0"'
    INPUTS.each { |input| assert_match(/^        #{input}:$/, @blueprint) }
  end

  def test_uses_one_safe_event_trigger
    assert_equal 1, @blueprint.scan(/event_type: yandex_speaker/).length
    assert_includes @blueprint, "event_value"
    assert_match(/event_value is string/, @blueprint)
    refute_match(/condition: trigger\n\s+id: turn_(?:on|off|toggle)/, @blueprint)
  end

  def test_queues_commands
    assert_match(/^mode: queued$/, @blueprint)
    assert_match(/^max: 10$/, @blueprint)
    assert_match(/^max_exceeded: warning$/, @blueprint)
  end

  def test_readme_mentions_queued_commands
    section = @readme[/#### \[Yandex Station Voice Control\].*?(?=\n---\n|\z)/m]
    refute_nil section
    assert_includes section, "queued"
  end
end
