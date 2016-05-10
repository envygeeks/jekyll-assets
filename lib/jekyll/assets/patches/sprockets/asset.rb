# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

module Sprockets
  class Asset

    # --
    # List all the liquid tags this asset used.
    # --
    def liquid_tags
      metadata[:liquid_tags] ||= begin
        Set.new
      end
    end


    # --
    # Pull out the data uri.
    # @return [String]
    # --
    def data_uri
      "data:#{content_type};base64,#{Rack::Utils.escape(
        Base64.encode64(to_s)
      )}"
    end
  end
end
