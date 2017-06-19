# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - MIT License
# Encoding: utf-8

RSpec.configure do |config|
  config.before :all do
    Pathutil.new("../../.asset-cache").expand_path(__FILE__)
      .rm_rf
  end
end
