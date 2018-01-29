# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class CSS < Default
        content_types "text/css"
        static rel: "stylesheet", type: "text/css"
        internal!

        # --
        def set_href
          return if @args[:inline]
          return @args[:href] = @asset.url if @asset.is_a?(Url)
          @args[:href] = @env.prefix_url(@asset
            .digest_path)
        end

        # --
        def set_integrity
          return unless integrity?
          @args[:integrity] = @asset.integrity
          if !@args.key?(:crossorigin) && @args[:integrity]
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
      css: {
        integrity: Jekyll.production?,
      },
    },
  })
end
