# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class CSS < Default
        types "text/css"
        static({
          rel: "stylesheet",
          type: "text/css",
        })

        def set_href
          @args[:href] = @env.prefix_url(@asset.digest_path)
        end

        def set_integrity
          @args[:integrity] = @asset.integrity
          unless @args.key?(:crossorigin)
            @args[:crossorigin] = "anonymous"
          end
        end
      end
    end
  end
end
