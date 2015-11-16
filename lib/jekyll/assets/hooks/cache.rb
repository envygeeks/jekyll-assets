# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  if (cache_dir = asset_config.fetch("cache", ".asset-cache"))
    self.cache = Sprockets::Cache::FileStore.new(jekyll.in_source_dir(cache_dir))
  end
end
