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
        def all
          @_all ||= {}
        end

        def trigger(base, point, *args)
          if all[base][point]
            then all[base][point].map do |v|
              v.call(*args)
            end
          end
        end

        def point(base, point)
          all[base][point] ||= Set.new
        end

        def register(base, point, &block)
          if HOOK_POINTS.has_key?(base) && HOOK_POINTS[base].include?(point)
             all[base] ||= {}
             point(base, point) << \
              block
          else
            raise UnknownHookError.new(base, point)
          end
        end
      end
    end
  end
end
