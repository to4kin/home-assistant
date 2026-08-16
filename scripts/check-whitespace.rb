#!/usr/bin/env ruby
# frozen_string_literal: true

tracked_files = IO.popen(["git", "ls-files", "-z"], &:read).split("\0")
violations = []

tracked_files.each do |path|
  next unless File.file?(path)

  content = File.binread(path)
  next if content.include?("\0")

  content.each_line.with_index(1) do |line, line_number|
    line_without_ending = line.delete_suffix("\n").delete_suffix("\r")
    violations << "#{path}:#{line_number}: trailing whitespace" if line_without_ending.end_with?(" ", "\t")
  end
end

unless violations.empty?
  warn violations.join("\n")
  exit 1
end

puts "Tracked files contain no trailing whitespace"
