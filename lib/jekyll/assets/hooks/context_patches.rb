Jekyll::Assets::Hook.register :env, :init do
  context_class.class_eval do
    alias_method :_old_asset_path, :asset_path
    def asset_path(asset, opts = {})
      out = _old_asset_path asset

      return unless out
      path = environment.find_asset(resolve(asset))
      environment.parent.used.add(path)
    out
    end
  end
end
