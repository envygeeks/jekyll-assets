Jekyll::Assets::Hook.register :env, :init do
  if (cache_dir = asset_config.fetch("cache", "tmp/.asset-cache"))
    self.cache = Sprockets::Cache::FileStore.new(jekyll.in_source_dir(cache_dir))
  end
end
