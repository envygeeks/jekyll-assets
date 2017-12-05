# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Img < Default
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_]+$!

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
        integrity: Jekyll.production?,
      },
    },
  })
end
