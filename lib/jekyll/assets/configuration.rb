module Jekyll
  module Assets
    module Configuration
      DEVELOPMENT = {
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
