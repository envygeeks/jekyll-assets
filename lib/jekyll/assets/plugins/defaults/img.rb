# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Img < Default
        types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
          "image/bmp", "image/gif", "image/png",
          "image/svg+xml"

        def set_src
          unless @args[:inline]
            @args[:src] = @env.prefix_url(@asset.digest_path)
          end
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
