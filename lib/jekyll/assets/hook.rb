# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
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
      class << self
        attr_reader :points
      end

      # --
      @points = {
        env: {
          before_init: {
            1 => [],
            2 => [],
            3 => [],
          },

          after_init: {
            1 => [],
            2 => [],
            3 => [],
          },

          after_write: {
            1 => [],
            2 => [],
            3 => [],
          },
        },

        config: {
          before_merge: {
            1 => [],
            2 => [],
            3 => [],
          },
        },

        asset: {
          before_compile: {
            1 => [],
            2 => [],
            3 => [],
          },
        },

        liquid: {
          pre_render: {
            1 => [],
            2 => [],
            3 => [],
          },
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
        @points[point[0]][point[1]] ||= {
          #
        }

        1.upto(3).each do |i|
          @points[point[0]][point[1]][i] ||= [
            #
          ]
        end

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
          .each_with_object([]) do |(_, v), a|
            a.concat(v)
          end
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
        get_point(*point).map do |v|
          block.call(v)
        end
      end

      # --
      # Register a hook on a hook point.
      # @param [Array<String,Symbol>] point the parent and child.
      # @param [Integer] priority your priority.
      # @note this is what plugins should use.
      # @return [nil]
      # --
      def self.register(*point, priority: 2, &block)
        if priority > 3
          raise ArgumentError,
            "priority must be between 1 and 3"
        end

        check_point(*point)
        out = @points[point[0]]
        out = out[point[1]]
        out = out[priority]
        out << block
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
