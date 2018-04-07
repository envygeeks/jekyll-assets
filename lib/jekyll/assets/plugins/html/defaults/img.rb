# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Img < Default
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_\+]+$!
        internal!

        # --
        def set_width
          unless args.key?(:width) || !config[:width]
            args[:width] = "100%"
          end
        end

        # --
        def set_height
          unless args.key?(:height) || !config[:height]
            args[:height] = "auto"
          end
        end

        # --
        def set_src
          dpath = @asset.digest_path
          return @args[:src] = @asset.url if @asset.is_a?(Url)
          return @args[:src] = @env.prefix_url(dpath) unless @args[:inline]
          @args[:src] = @asset.data_uri
        end

        # --
        def set_integrity
          return unless integrity?
          @args[:integrity] = @asset.integrity
          unless @args.key?(:crossorigin)
            @args[:crossorigin] = "anonymous"
          end
        end

        # --
        def integrity?
          config[:integrity] && !@asset.is_a?(Url) &&
            !@args.key?(:integrity)
        end
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    defaults: {
      img: {
        height: false,
        integrity: Jekyll.production?,
        width: false,
      },
    },
  })
end
