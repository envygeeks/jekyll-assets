module Jekyll
  module Assets
    module Helpers
      extend Forwardable::Extended
      rb_delegate :manifest, {
        :to => :parent
      }

      # --
      # @param [String] path the path you wish to resolve.
      # Find the path to the asset.
      # --
      def asset_path(path, opts = {})
        return path if Pathname.new(path).absolute?
        asset = manifest.find(path).first

        if asset
          manifest.add(asset)
          parent.prefix_path(
            parent.digest?? asset.digest_path : asset.logical_path
          )
        else
          path
        end
      end

      # --
      # @param [String] path the path you wish to resolve.
      # Pull the asset path and wrap it in url().
      # --
      def asset_url(path, opts = {})
        "url(#{asset_path(
          path, opts
        )})"
      end

      # --
      # Get access to the actual asset environment.
      # @return [Jekyll::Assets::Env]
      # --
      def parent
        environment.is_a?(Cached) ? environment.parent : environment
      end

      # --
      # Creates font_url, font_path, image_path, image_url,
      # img_path, and img_url for your pleasure.
      # --
      %W(font image img).each do |key|
        define_method "#{key}_path" do |*args|
          asset_path(
            *args
          )
        end

        #

        define_method "#{key}_url" do |*args|
          asset_url(
            *args
          )
        end
      end
    end
  end
end

#

module Sprockets
  class Context
    prepend Jekyll::Assets::Helpers
  end
end
