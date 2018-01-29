# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Component < Default
        content_types "text/html"
        internal!

        # --
        def set_href
          dpath = @asset.digest_path
          return @args[:href] = @asset.url if @asset.is_a?(Url)
          return @args[:href] = @env.prefix_url(dpath) unless @args[:inline]
          @args[:href] = @asset.data_uri
        end

        # --
        def set_rel
          @args[:rel] = "import"
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
      component: {
        integrity: Jekyll.production?,
      },
    },
  })
end
