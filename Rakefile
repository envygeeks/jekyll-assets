# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

$stderr = StringIO.new
require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"
$stderr = STDERR

# --
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop) { |t| t.options = %w(--format=e --parallel) }
Rake::Task[:spec].enhance { Rake::Task[:rubocop].invoke }
task default: %i(spec rubocop)
