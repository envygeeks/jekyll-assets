# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init do
  cache_dir = asset_config.fetch("cache", ".asset-cache")

  if cache_dir
    self.cache = Sprockets::Cache::FileStore.new(
      jekyll.in_source_dir(cache_dir)
    )
  end
end
