# frozen_string_literal: true

require "minitest/autorun"

ROOT = File.expand_path("../..", __dir__)

class WorkflowSeparationTest < Minitest::Test
  def read(path)
    full_path = File.join(ROOT, path)
    assert File.file?(full_path), "Expected #{path} to exist"
    File.read(full_path)
  end

  def test_validation_does_not_run_regression_tests
    validation = read("scripts/validate-public.sh")

    refute_includes validation, "find tests"
    refute_match(/ruby\s+.*_test\.rb/, validation)
  end

  def test_test_script_discovers_all_minitest_files_and_fails_when_empty
    test_script = read("scripts/test.sh")

    assert_includes test_script, "find tests -type f -name '*_test.rb' -print0"
    assert_includes test_script, 'ruby "$test_file"'
    assert_includes test_script, "No Ruby tests found"
    assert_includes test_script, "exit 1"
  end

  def test_tests_workflow_is_independent
    workflow = read(".github/workflows/tests.yml")

    assert_includes workflow, "name: Tests"
    assert_includes workflow, "pull_request:"
    assert_includes workflow, "- main"
    assert_includes workflow, "contents: read"
    assert_includes workflow, "bash scripts/test.sh"
    refute_includes workflow, "validate-public.sh"
  end

  def test_validate_workflow_remains_validation_only
    workflow = read(".github/workflows/validate.yml")

    assert_includes workflow, "name: Validate"
    assert_includes workflow, "bash scripts/validate-public.sh"
    refute_includes workflow, "scripts/test.sh"
  end

  def test_readme_lists_both_local_entry_points
    readme = read("README.md")

    assert_includes readme, "bash scripts/validate-public.sh"
    assert_includes readme, "bash scripts/test.sh"
  end
end
