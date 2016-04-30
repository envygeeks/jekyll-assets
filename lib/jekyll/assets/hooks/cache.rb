# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  cache_dir = asset_config.fetch("cache", ".asset-cache")
  cache_typ = asset_config.fetch("cache_type",
    "filesystem"
  )

  if cache_dir != false && cache_typ != "memory"
    self.cache = begin
      Sprockets::Cache::FileStore.new(
        jekyll.in_source_dir(
          cache_dir
        )
      )
    end

  elsif cache_typ == "memory"
    self.cache = begin
      Sprockets::Cache::MemoryStore.new
    end
  end
end
