module Jekyll
  module Assets
    module Configuration
      DEVELOPMENT = {
        "skip_prefix_with_cdn" => false,
        "prefix"    => "/assets",
        "digest"    => false,
        "assets"    => [],

        "compress"  => {
          "css"     => false,
          "js"      => false
        },

        "sources"   => [
          "_assets/css", "_assets/stylesheets",
          "_assets/images", "_assets/img", "_assets/fonts",
          "_assets/javascripts", "_assets/js"
        ]
      }

      PRODUCTION = DEVELOPMENT.merge({
        "digest"    => true,
        "compress"  => {
          "css"     => true,
          "js"      => true
        },
      })

      def self.defaults
        %W(development test).include?(Jekyll.env) ? DEVELOPMENT : PRODUCTION
      end

      def self.merge(merge_into, config = self.defaults)
        merge_into = merge_into.dup
        config.each_with_object(merge_into) do |(k, v), h|
          if !h.has_key?(k) || (v.is_a?(Hash) && !h[k])
            h[k] = v

          elsif v.is_a?(Hash)
            h[k] = merge h[k], \
              v
          end
        end

        merge_into
      end
    end
  end
end
