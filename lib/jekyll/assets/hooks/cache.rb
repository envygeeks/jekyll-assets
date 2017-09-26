# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  cache = asset_config.fetch("cache", ".asset-cache")
  type  = asset_config.fetch("cache_type", "file")

  self.cache = Sprockets::Cache::MemoryStore.new if cache && type == "memory"
  self.cache = Sprockets::Cache::FileStore.new(cache_path) if cache && type == "file"
  self.cache = Sprockets::Cache::NullStore.new if !cache
end
