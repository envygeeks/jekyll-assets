# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Sprockets
  class Asset
    def data_uri
      "data:#{content_type};base64,#{Rack::Utils.escape(
        Base64.encode64(to_s))}"
    end
  end
end
