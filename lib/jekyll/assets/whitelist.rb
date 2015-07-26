module Jekyll
  module Assets
    class Whitelist
      def initialize(list, opts)
        @opts, @list = opts, list
      end

      # XXX: Doc

      def process
        @list.inject({}) do |h, k|
          val = @opts[k] || @opts[k.is_a?(String) ? k.to_sym : k.to_s]
          if !val.nil?
            h.update k => val
          end

          h
        end
      end
    end
  end
end
