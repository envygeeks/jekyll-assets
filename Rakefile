require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

require "rubocop/rake_task"
Rubocop::RakeTask.new

task :default => [:spec, :rubocop]
