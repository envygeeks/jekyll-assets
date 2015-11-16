module Jekyll
  module Assets
    class Hook
      class UnknownHookError < RuntimeError
        def initialize(base: nil, point: nil)
          return super "Unknown hook  base '#{base}'" if base
          return super "Unknown hook point '#{point}' given."
        end
      end

      HookAliases = {
        :env => {
          :post_init => :init,
           :pre_init => :init
        }
      }

      HookPoints = {
        :env => [
          :init
        ]
      }

      def self.all
        @_all ||= {}
      end

      # Trigger a hook, giving an optional block where we pass you the,
      # proc we got and then you can do as you please (such as instance eval)
      # but if you do not give us one then we simply pass the args.

      def self.trigger(base, _point, *args, &block)
        raise ArgumentError, "Do not give args with a block" if args.size > 0 && block_given?
        if all.has_key?(base) && all.fetch(base).has_key?(_point)
          Set.new.merge(point(base, _point, :early)).merge(point(base, _point)).map do |v|
            block_given?? block.call(v) : v.call(*args)
          end
        end
      end

      #

      def self.point(base, point, _when = :late)
        point = all.fetch(base).fetch(point, nil) || all.fetch(base).store(point, {
          :late => Set.new, :early => Set.new })
        point.fetch(_when)
      end

      #

      def self.register(base, point, _when = :late, &block)
        raise UnknownHookError.new(base: base) unless HookPoints.has_key?(base)
        point = HookAliases.fetch(base).fetch(point) if HookAliases.fetch(base, {}).has_key?(point)
        raise UnknownHookError.new(point: point) unless HookPoints.fetch(base).include?(point)
        all.fetch(base, nil) || all.store(base, {})
        point(base, point, _when).add(block)
      end
    end
  end
end
