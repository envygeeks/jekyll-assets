# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

RSpec.configure do |c|
  beta = Gem::Version.new("4.0.beta")
  version = Gem::Version.new(Sprockets::VERSION)
  c.filter_run_excluding sprockets: 3 if version > beta
  c.filter_run_excluding sprockets: 4 if version < beta
end
