module Jekyll
  module Assets
    class Whitelist
      def initialize(list, opts)
        @opts, @list = opts, list
      end

      def process
        @list.inject({}) do |h, k|
          val = @opts[k] || @opts[k.is_a?(String) ? k.to_sym : k.to_s]
          h.update k => val if !val.nil?
        h
        end
      end
    end
  end
end
