module Jekyll
  module AssetsPlugin
    class Environment
      module ContextPatch

        def site
          self.class.instance_variable_get :@site
        end


        def asset_path *args
          "#{site.assets_config.baseurl}/#{site.assets[*args].digest_path}"
        end

      end
    end
  end
end
