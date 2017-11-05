# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

$VERBOSE = nil
require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# --
RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)
task default: %i(spec rubocop)

# --
Rake::Task[:spec].enhance do
  Rake::Task[:rubocop].invoke
end
