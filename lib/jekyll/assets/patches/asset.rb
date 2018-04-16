# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module Asset
        attr_accessor :environment

        # --
        # @note see the configuration.
        # Provides the digest path, or non-digest path.
        # @return [String]
        # --
        def digest_path
          environment.asset_config[:digest] ? super : logical_path
        end

        # --
        # Returns the data uri.
        # @return [String]
        # --
        def data_uri
          "data:#{content_type};base64,#{Rack::Utils.escape(
            Base64.encode64(to_s))}"
        end
      end
    end
  end
end

# --
module Sprockets
  class Asset
    prepend Jekyll::Assets::Patches::Asset
  end
end
