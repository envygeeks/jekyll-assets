# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    Context = Class.new(defined?(Liquid::ParseContext) ?
      Liquid::ParseContext : Array)
  end
end
