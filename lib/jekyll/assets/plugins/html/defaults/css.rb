# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class CSS < Default
        static rel: "stylesheet"
        content_types "text/css"
        static type: "text/css"

        def set_href
          return @args[:href] = @asset.url if @asset.is_a?(Url)
          @args[:href] = @env.prefix_url(@asset
            .digest_path)
        end

        def set_integrity
          return if @asset.is_a?(Url)
          @args[:integrity] = @asset.integrity
          if !@args.key?(:crossorigin) && @args[:integrity]
            @args[:crossorigin] = "anonymous"
          end
        end
      end
    end
  end
end
