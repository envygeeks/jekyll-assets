# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  context_class.class_eval do
    alias_method :_old_asset_path, :asset_path
    def asset_path(asset, _ = {})
      out = _old_asset_path asset

      return unless out
      path = environment.find_asset(resolve(asset))
      environment.parent.used.add(path)
      out
    end
  end
end
