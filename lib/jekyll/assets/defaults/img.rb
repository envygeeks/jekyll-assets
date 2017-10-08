# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImgDefaults < Jekyll::Assets::Liquid::Default
        type %r!^image\/[a-zA-Z]+$!

        # --
        # set_src sets the source path.
        # @return [nil]
        # --
        def set_src
          @args[:src] = @env.prefix_path(@asset.digest_path)
        end

        # --
        # @note override with {% img alt="" %}
        # set_alt provides the `alt=""` atttribute
        # @return [nil]
        # --
        def set_alt
          unless @args.key?(:alt)
            @args[:alt] = File.basename(@asset.logical_path)
          end
        end

        # --
        # set_dimensions provides a default dimensions.
        # @note override with {% img width="" height="" %}
        # @return [nil]
        # --
        def set_dimensions
          @args[:width], @args[:height] = FastImage.
            size(@asset.filename.to_s)
        end

        # --
        # set_integrity sets integrity, and origin.
        # @note override with {% img crossorigin="" %}
        # @return [nil]
        # --
        def set_integrity
          @args[:integrity] = @asset.integrity
          @args[:crossorigin] = "anonymous" \
            unless @args[:crossorigin]
        end
      end
    end
  end
end
