require "rubygems"

require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require_relative "../lib/jekyll/assets"

require "jekyll"
require "liquid"
require "sprockets"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support", __FILE__) + "/**/*.rb"]
  .each { |f| require f }

# rubocop:disable Metrics/AbcSize
def start_site
  if Gem::Version.new("2") <= Gem::Version.new(Jekyll::VERSION)
    Jekyll.logger.log_level = :warn
  else
    Jekyll.logger.log_level = Jekyll::Stevenson::WARN
  end

  @dest = fixtures_path.join("_site")
  @site = Jekyll::Site.new(Jekyll.configuration({
    "source"      => fixtures_path.to_s,
    "destination" => @dest.to_s
  }))

  @dest.rmtree if @dest.exist?
  @site.process
end
# rubocop:enable Metrics/AbcSize

RSpec.configure do |config|
  config.include FixturesHelpers
  config.extend  FixturesHelpers
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.before(:all) do
    Jekyll::Assets::HOOKS.clear
    start_site
  end

  config.after(:all) do
    @dest.rmtree if @dest.exist?
  end
end
