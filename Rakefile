# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

ogv = $VERBOSE
$VERBOSE = nil
require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"
$VERBOSE = ogv

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)
task default: [:spec]
