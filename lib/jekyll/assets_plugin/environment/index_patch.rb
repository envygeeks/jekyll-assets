module Jekyll
  module AssetsPlugin
    class Environment
      module IndexPatch

        def find_asset path, options = {}
          asset = super
          @environment.site.bundle_asset! asset if asset and options[:bundle]
          asset
        end

      end
    end
  end
end
