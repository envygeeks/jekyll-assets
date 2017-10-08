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
      POINTS = {
        env: {
          init: {
            1 => [],
            2 => [],
            3 => [],
          }
        }
      }

      # --
      # @param [Array<Symbol>] *point the point path.
      # add_point allows you to add a hook point to our hooks.
      # @return [Hash]
      # --
      def self.add_point(*point)
        raise ArgumentError, "only give 2 points" if point.count > 2

        POINTS[point[0]] ||= {}
        POINTS[point[0]][point[1]] ||= {
          #
        }

        1.upto(3).each do |i|
          POINTS[point[0]][point[1]][i] ||= [
            #
          ]
        end

        POINTS
      end


      # --
      # @param [Array<Symbol>] *point the point path.
      # get_point will try and retrieve (or create and/loop).
      # @return [Array<Proc>]
      # --
      def self.get_point(*point)
        check_point(*point)

        POINTS[point[0]][point[1]].
        each_with_object([]) do |(_, v), a|
          a.push(*v)
        end
      end

      # --
      # @param [Array<>] *point the point.
      # trigger allows you to trigger a hook
      # @return [nil]
      # --
      def self.trigger(*point, &block)
        get_point(*point).map do |v|
          block.call(v)
        end
      end

      # --
      def self.register(*point, priority: 3, &block)
        raise ArgumentError, "priority must be between 1 and 3" if priority > 3

        check_point(*point)
        out = POINTS[point[0]]
        out = out[point[1]]
        out = out[priority]
        out << block
      end

      # --
      private
      def self.check_point(*point)
        raise ArgumentError, "only give 2 points" if point.count > 2
        unless POINTS.key?(point[0]) && POINTS[point[0]].key?(point[1])
          raise ArgumentError, "Unknown hook #{point}"
        end
      end
    end
  end
end
