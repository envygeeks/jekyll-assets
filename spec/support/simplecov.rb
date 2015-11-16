# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

unless ENV["DISABLE_COVERAGE"]
  require "envygeeks/coveralls"
  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/vendor/"
  end
end
