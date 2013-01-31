# 3rd-party
require 'liquid'
require 'tilt'


module Jekyll
  module AssetsPlugin
    class LiquidProcessor < Tilt::Template
      def prepare
        @engine = Liquid::Template.parse data
      end

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
