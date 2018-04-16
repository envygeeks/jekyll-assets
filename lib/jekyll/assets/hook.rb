# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Hook
      autoload :Point, "jekyll/assets/hook/point"

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
        raise ArgumentError, "only 2 points" if point.count > 2
        Logger.debug "registering hook point - #{point.inspect}"

        @points[point[0]] ||= {}
        @points[point[0]][point[1]] ||= []
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
        out = @points[point[0]][point[1]]
        out.sort_by(&:priority)
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
        Logger.debug "messaging hook point #{point.inspect}"
        hooks.map { |v| block.call(v.block) }
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
        Logger.debug "registering hook on point #{point.inspect}"
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
