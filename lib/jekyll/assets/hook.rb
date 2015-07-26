module Jekyll
  module Assets
    class Hook
      class UnknownHookError < RuntimeError
        def initialize(base, point)
          super "Unknown jekyll-assets hook point (#{point}) or base (#{base}) given."
        end
      end

      HOOK_POINTS = {
        :env => [
          :pre_init, :post_init
        ]
      }

      class << self

        # XXX: Doc

        def hooks
          @_hooks ||= {}
        end

        # XXX: Doc

        def trigger(base, point, *args)
          if hooks[base][point]
            then hooks[base][point].map do |v|
              v.call(*args)
            end
          end
        end

        # XXX: Doc

        def register(base, point, &block)
          if HOOK_POINTS.has_key?(base) && HOOK_POINTS[base].include?(point)
             hooks[base] ||= {}
            (hooks[base][point] ||= Set.new) << \
              block
          else
            raise UnknownHookError.new(base, point)
          end
        end
      end
    end
  end
end
