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
    end
  end
end
