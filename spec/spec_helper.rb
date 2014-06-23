require "rubygems"

require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter
]

SimpleCov.start

require "jekyll"
require "liquid"
require "sprockets"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support", __FILE__) + "/**/*.rb"]
  .each { |f| require f }

RSpec.configure do |config|
  config.include FixturesHelpers
  config.extend  FixturesHelpers

  config.disable_monkey_patching!

  config.before(:all) do
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

  config.after(:all) do
    @dest.rmtree if @dest.exist?
  end
end
