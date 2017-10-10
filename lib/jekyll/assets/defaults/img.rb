# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImgDefaults < Liquid::Default
        types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
          "image/bmp", "image/gif", "image/png"

        def set_src
          src = @asset.digest_path
          src = @env.prefix_path(src)
          @args[:src] = src
        end

        def set_alt
          return if @args.key?(:alt)
          alt = @asset.logical_path
          alt = File.basename(alt)
          @args[:alt] = alt
        end

        def set_dimensions
          return if @args.key?(:width) || @args.key?(:height)
          img = FastImage.size(@asset.filename.to_s)
          @args[:width], @args[:height] = img
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
