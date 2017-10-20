# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "liquid/parse_context"

module Jekyll
  module Assets

    # --
    # Provides a context for Liquid.
    # @note this is like this because of Jekyll... who upgraded
    #   in a breaking way between 3.4 and 3.5 and wouldn't fix the
    #   problem, claiming it "wasn't a problem"
    # --
    Context = Class.new(defined?(Liquid::ParseContext) ?
      Liquid::ParseContext : Array)
  end
end
