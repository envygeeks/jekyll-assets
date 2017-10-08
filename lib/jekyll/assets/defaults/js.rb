# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class JSDefaults < Liquid::Default
        type "text/javascript"
        static_defaults({
          type: "text/javascript"
        })

        # --
        # set_src sets the source path.
        # @return [nil]
        # --
        def set_src
          @args[:src] = @env.prefix_path(@asset.digest_path)
        end

        # --
        # set_integrity sets integrity, and origin.
        # @note override with {% js crossorigin="" %}
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
