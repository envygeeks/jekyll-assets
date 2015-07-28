module Sprockets
  class Asset
    def data_uri
      "data:#{content_type};base64,#{Rack::Utils.escape \
        Base64.encode64(to_s)}"
    end

    def liquid_tags
      metadata[:liquid_tags] ||= \
        Set.new
    end
  end
end
