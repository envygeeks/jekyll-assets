# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - MIT License
# Encoding: utf-8

unless ENV["CI"] == "true"
  RSpec.configure do |c|
    c.profile_examples = true
  end
end
