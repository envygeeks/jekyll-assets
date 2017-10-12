# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Default
      class Img < Default
        types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
          "image/bmp", "image/gif", "image/png"

        def set_src
          @args[:src] = @env.prefix_path(
            @asset.digest_path
          )
        end

        def set_alt
          return if @args.key?(:alt)
          alt = @asset.logical_path
          alt = File.basename(alt)
          @args[:alt] = alt
        end

        def set_dimensions
          @args[:width], @args[:height] = FastImage.size(
            @asset.filename.to_s
          )
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
