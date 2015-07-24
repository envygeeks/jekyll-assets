module Jekyll
  module Assets
    class Context
      def initialize(context)
        patch context
      end

      # Patches context_class so that we can override Sprockets::Helpers
      # base helpers so that we can run it's method but also ensure that the
      # asset gets added to the used list on Jekyll::Assets::Env.

      def patch(what)
        what.class_eval do
          alias_method :_old_asset_path, :asset_path
          def asset_path(asset, opts = {})
            out = _old_asset_path asset, opts = {}
            return unless out

            environment.parent.used.add(environment.find_asset( \
              resolve(asset)))
          out
          end
        end
      end
    end
  end
end
