# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Hook
      class UnknownHookError < RuntimeError
        def initialize(point)
          super "Unknown hook point `#{point}'"
        end
      end

      # --
      class Point
        attr_accessor :block, :priority

        # --
        # A hook point only holds data for later, it
        # really serves no other purpose for now, other
        # than to make live easier for handling hooks
        # and their sorting, later in stream.
        # --
        def initialize(priority, &block)
          @priority, @block = priority, block
        end
      end

      # --
      class << self
        attr_reader :points
      end

      # --
      @points = {
        env: {
          before_init: [],
          after_init: [],
          after_write: [],
        },

        config: {
          before_merge: [],
        },

        asset: {
          before_compile: [],
          before_read: [],
          after_read: [],
          after_compression: [],
          before_write: [],
          after_write: [],
        },

        liquid: {
          before_render: [],
        },
      }

      # --
      # Create a hook point to attach hooks to.
      # @param [Array<String,Symbol>] point the parent and child.
      # @note plugins can create their own points if wished.
      # @return [Hash<Hash<Array>>]
      # --
      def self.add_point(*point)
        raise ArgumentError, "only give 2 points" if point.count > 2

        @points[point[0]] ||= {}
        @points[point[0]][point[1]] ||= {}
        @points
      end

      # --
      # @return [Array<Proc>]
      # @param [Array<String,Symbol>] point the parent and child.
      # @note this is really internal.
      # Get a hook point.
      # --
      def self.get_point(*point)
        check_point(*point)
        @points[point[0]][point[1]]
          .sort_by(&:priority)
      end

      # --
      # Trigger a hook point.
      # @note plugins can trigger their own hooks.
      # @param [Array<String,Symbol>] point the parent and child.
      # @param [Proc{}] block the code to run.
      # @see self.add_point
      # @return [nil]
      # --
      def self.trigger(*point, &block)
        hooks = get_point(*point)
        Logger.debug "messaging hooks on #{point.last} " \
          "through #{point.first}"

        hooks.map do |v|
          block.call(v.block)
        end
      end

      # --
      # Register a hook on a hook point.
      # @param [Array<String,Symbol>] point the parent and child.
      # @param [Integer] priority your priority.
      # @note this is what plugins should use.
      # @return [nil]
      # --
      def self.register(*point, priority: 48, &block)
        check_point(*point)
        point_ = Point.new(priority, &block)
        out = @points[point[0]]
        out = out[point[1]]
        out << point_
      end

      # --
      # @param point the points to check.
      # Checks that a point exists or raises an error.
      # @return [nil]
      # --
      def self.check_point(*point)
        raise ArgumentError, "only give 2 points" if point.count > 2
        if !@points.key?(point[0]) || !@points[point[0]].key?(point[1])
          raise ArgumentError, "Unknown hook #{point}"
        end
      end
    end
  end
end
