module Jekyll
  module Assets
    class Context
      def initialize(context)
        patch context
      end

      # Patches `#context_class` so that we can override Sprockets::Helpers
      # to track the used assets on our environment, this way when you update
      # an asset you don't lose any of the images and think that they're
      # gone... only to never return to us.

      def patch(what)
        what.class_eval do
          alias_method :_old_asset_path, :asset_path
          def asset_path(asset, opts = {})
            out = _old_asset_path asset, opts = {}
            return unless out

            environment.parent.used.add(environment.find_asset \
              resolve(asset))
          out
          end
        end
      end
    end
  end
end
