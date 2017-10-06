module Jekyll
  module Assets
    module Plugins
      class CSSDefaults < Liquid::Default
        tags :css
        defaults({
          type: "text/css"
        })

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
