# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  module Assets
    class Hook
      class UnknownHookError < RuntimeError
        def initialize(base: nil, point: nil)
          super "Unknown hook #{base ? "base" : "point"} '#{base || point}'"
        end
      end

      # ----------------------------------------------------------------------

      HOOK_ALIASES = {
        :env => {
          :post_init => :init,
          :pre_init  => :init
        }
      }

      # ----------------------------------------------------------------------

      HOOK_POINTS = {
        :env => [
          :init
        ]
      }

      # ----------------------------------------------------------------------

      def self.all
        @_all ||= {}
      end

      # ----------------------------------------------------------------------
      # Trigger a hook, giving an optional block where we pass you the,
      # proc we got and then you can do as you please (such as instance eval)
      # but if you do not give us one then we simply pass the args.
      # ----------------------------------------------------------------------

      def self.trigger(base, point_, *args, &block)
        raise ArgumentError, "Do not give args with a block" if !args.empty? && block_given?
        if all.key?(base) && all[base].key?(point_)
          Set.new.merge(point(base, point_, :early)).merge(point(base, point_)).map do |v|
            block_given?? block.call(v) : v.call(*args)
          end
        end
      end

      # ----------------------------------------------------------------------

      def self.point(base, point, when_ = :late)
        point = all[base][point] ||= {
          :early => Set.new,
          :late  => Set.new
        }

        point[when_]
      end

      # ----------------------------------------------------------------------

      def self.register(base, point, when_ = :late, &block)
        raise UnknownHookError, base: base unless HOOK_POINTS.key?(base)
        point = HOOK_ALIASES[base][point] if HOOK_ALIASES.fetch(base, {}).key?(point)
        raise UnknownHookError, point: point unless HOOK_POINTS[base].include?(point)
        all[base] ||= {}

        point(base, point, when_) \
          .add(block)
      end
    end
  end
end
