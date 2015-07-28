module Jekyll
  module Assets
    class Context
      def initialize(context)
        patch context
      end

      def patch(what)
        what.class_eval do
          alias_method :_old_asset_path, :asset_path
          def asset_path(asset, opts = {})
            out = _old_asset_path asset
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
