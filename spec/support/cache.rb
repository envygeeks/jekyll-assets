# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - MIT License

RSpec.configure do |config|
  config.before :all do
    Pathutil.new("../.jekyll-cache").expand_path(__dir__).rm_rf
  end
end
