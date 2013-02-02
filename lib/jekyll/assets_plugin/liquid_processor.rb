# 3rd-party
require 'tilt'


module Jekyll
  module AssetsPlugin
    class LiquidProcessor < Tilt::LiquidTemplate
      def evaluate context, locals, &block
        @engine.render locals, {
          :filters   => [Jekyll::Filters],
          :registers => {
            :site => context.site
          }
        }
      end
    end
  end
end
