module Jekyll
  module AssetsPlugin
    class Environment
      module IndexPatch

        def find_asset path, options = {}
          site    = @environment.site
          asset   = super
          bundle  = options[:bundle]

          if asset and bundle and not site.static_files.include? asset
            site.static_files << AssetFile.new(site, asset)
          end

          asset
        end

      end
    end
  end
end
