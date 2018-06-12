# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Hook
      class Point
        attr_accessor :priority, :block

        # --
        # @see Jekyll::Assets::Hook
        # Hold hook data for a later time
        # @param p [Integer] the priority (any int)
        # @param b [Proc] the code to run
        # @return [self]
        # --
        def initialize(p, &b)
          @priority, @block = p, b
        end
      end
    end
  end
end
