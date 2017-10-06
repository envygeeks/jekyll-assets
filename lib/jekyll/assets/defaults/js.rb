module Jekyll
  module Assets
    module Plugins
      class JSDefaults < Liquid::Default
        tags :js
        defaults({
          type: "text/javascript"
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
