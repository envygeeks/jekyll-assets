require "rspec"
require "support/simplecov"
require "luna/rspec/formatters/checks"
require "jekyll/assets"
require "jekyll"

Dir[File.expand_path("../../support/*.rb", __FILE__)].each do |v|
  require v
end
