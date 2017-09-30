# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class IntegrityDefault < Jekyll::Assets::Liquid::Tag::Default
        FOR = %w(css javascript js)

        # --
        # run runs the default we wish to set.
        # @return [nil]
        # --
        def run
          integrity
        end

        # --
        # integrity will provide the `intergrity=""` and
        # the `crossorigin=""` for your assets for you so
        # that browsers can verify your assets.
        # @return [nil]
        # --
        def integrity
          digest = Digest::SHA384.digest(@asset.to_s)
          digest = Sprockets::DigestUtils.
            integrity_uri(digest)

          if @env.asset_config["integrity"]
            @args[:integrity] = digest
            unless @args[:crossorigin]
              @args[:crossorigin] = "anonymous"
            end
          end
        end
      end
    end
  end
end
