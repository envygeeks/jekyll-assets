module Jekyll
  module Assets
    module Config
      Development = {
        "skip_baseurl_with_cdn" => false,
        "skip_prefix_with_cdn"  => false,
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

      # -----------------------------------------------------------------------

      Production = Development.merge({
        "digest"    => true,
        "compress"  => {
          "css"     => true,
          "js"      => true
        },
      })

      # -----------------------------------------------------------------------

      def self.defaults
        %W(development test).include?(Jekyll.env) ? Development : Production
      end

      # -----------------------------------------------------------------------

      def self.merge(nhash, ohash = defaults)
        ohash.merge(nhash) do |key, oval, nval|
          oval.is_a?(Hash) && nval.is_a?(Hash) ? merge(nval, oval) : nval
        end
      end
    end
  end
end
