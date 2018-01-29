# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class Default
      class Video < Default
        content_types %r!^video/.*$!
        internal!

        # --
        def set_src
          dpath = asset.digest_path
          return args[:src] = asset.url if asset.is_a?(Url)
          return args[:src] = env.prefix_url(dpath) unless args[:inline]
          # This is insanity, but who am I to judge you, and what you do.
          args[:src] = asset.data_uri
        end

        # --
        def set_controls
          return if args.key?(:controls)

          args[:controls] = true
          unless args.key?(:controlsList) || args.key?(:controlslist)
            args[:controlList] = "nodownload"
          end
        end

        # --
        def set_integrity
          return unless integrity?

          args[:integrity] = asset.integrity
          unless args.key?(:crossorigin)
            args[:crossorigin] = "anonymous"
          end
        end

        # --
        def integrity?
          config[:integrity] && !asset.is_a?(Url) &&
            !args.key?(:integrity)
        end
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    defaults: {
      video: {
        integrity: Jekyll.production?,
      },
    },
  })
end
