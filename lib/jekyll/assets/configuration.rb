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

      # Merges the users configuration with the default configuration so
      # that there is always some form of stable configuration for you to tap
      # into.  This is merged into `#asset_config`.

      def self.merge(merge_into, config = nil)
        config ||= %(development test).include?(Jekyll.env) ? DEVELOPMENT : PRODUCTION
        merge_into = merge_into.dup

        config.each_with_object(merge_into) do |(key, value), hash|
          if !hash.has_key?(key) || (value.is_a?(Hash) && !hash[key])
            hash[key] = \
              value

          elsif value.is_a?(Hash)
            hash[key] = merge hash[key], \
              value
          end
        end

        merge_into
      end
    end
  end
end
