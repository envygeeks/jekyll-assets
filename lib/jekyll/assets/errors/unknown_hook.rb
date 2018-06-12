# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Errors
      module UnknownHook

        # --
        # Throws an error.
        # @param point [Object] the point
        # @raise a crazy error.
        # --
        def initialize(point)
          super "Unknown hook point `#{point}'"
        end
      end
    end
  end
end
