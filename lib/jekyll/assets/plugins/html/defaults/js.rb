# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class JS < Default
        content_types "application/javascript"
        static type: "text/javascript"

        # --
        def set_src
          return if @args[:inline]
          return @args[:src] = @asset.url if @asset.is_a?(Url)
          @args[:src] = @env.prefix_url(@asset
            .digest_path)
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
            !@args.key?(:integrity) && !@args[:inline]
        end
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    defaults: {
      js: {
        integrity: Jekyll.production?,
      },
    },
  })
end
