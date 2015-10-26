Jekyll::Assets::Hook.register :env, :init, :early do
  jekyll.config.store("assets", Jekyll::Assets::Config.merge(asset_config))
end
