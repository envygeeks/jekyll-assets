# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module Sprockets
        module Asset
          attr_accessor :environment

          # --
          def digest_path
            environment.asset_config[:digest] ? \
              super : logical_path
          end

          # --
          def data_uri
            "data:#{content_type};base64,#{Rack::Utils.escape(
              Base64.encode64(to_s))}"
          end
        end
      end
    end
  end
end

# --
module Sprockets
  class Asset
    prepend Jekyll::Assets::Patches::Sprockets::Asset
  end
end
