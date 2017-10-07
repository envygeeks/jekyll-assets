# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class JSDefaults < Liquid::Default
        tags :js
        defaults({
          type: "text/javascript"
        })

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
