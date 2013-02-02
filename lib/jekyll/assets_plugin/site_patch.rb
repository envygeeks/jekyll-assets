# 3rd-party
require "jekyll"


# internal
require "jekyll/assets_plugin/configuration"
require "jekyll/assets_plugin/environment"


module Jekyll
  module AssetsPlugin
    module SitePatch

      def assets_config
        @assets_config ||= Configuration.new(self.config["assets"] || {})
      end


      def assets
        @assets ||= Environment.new self
      end

    end
  end
end


Jekyll::Site.send :include, Jekyll::AssetsPlugin::SitePatch
