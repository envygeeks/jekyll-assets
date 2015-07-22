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
