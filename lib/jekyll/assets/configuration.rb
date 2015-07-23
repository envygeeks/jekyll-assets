module Jekyll
  module Assets
    module Configuration
      DEVELOPMENT = {
        "skip_prefix_with_cdn" => false,
        "force_cdn" => false,
        "prefix"    => "/assets",
        "digest"    => false,
        "compress"  => {
          "css"     => false,
          "js"      => false
        },

        "sources"   => [
          "_assets/css", "_assets/stylesheets",
          "_assets/images", "_assets/img", "_assets/fonts",
          "_assets/javascripts", "_assets/js"
        ],

        "assets"    => [
          #
        ]
      }. \
      freeze

      #

      PRODUCTION = DEVELOPMENT.merge({
        "digest"    => true,
        "compress"  => {
          "css"     => true,
          "js"      => true
        },
      }). \
      freeze
    end
  end
end
