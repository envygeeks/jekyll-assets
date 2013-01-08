module Jekyll
  module AssetsPlugin
    module Filters
      STYLESHEET = '<link rel="stylesheet" type="text/css" href="%s">'
      JAVASCRIPT = '<script type="text/javascript" src="%s"></script>'

      def asset logical_path
        with_asset logical_path.strip do |asset, site|
          return asset.to_s
        end
      end

      def asset_path logical_path
        with_asset logical_path.strip do |asset, site|
          unless site.static_files.include? asset
            site.static_files << AssetFile.new(site, asset)
          end

          return "#{site.assets_config.baseurl.chomp '/'}/#{asset.digest_path}"
        end
      end

      def javascript logical_path
        logical_path.strip!
        logical_path << '.js' if File.extname(logical_path).empty?

        JAVASCRIPT % asset_path(logical_path)
      end

      def stylesheet logical_path
        logical_path.strip!
        logical_path << '.css' if File.extname(logical_path).empty?

        STYLESHEET % asset_path(logical_path)
      end

      protected

      def with_asset path, &block
        site  = @context.registers[:site]
        asset = site.assets[path]

        raise AssetFile::NotFound, "couldn't find file '#{path}'" unless asset

        yield asset, site
      end
    end
  end
end
