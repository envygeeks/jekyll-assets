# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  cache = asset_config.fetch("cache", ".asset-cache")
  type  = asset_config.fetch("cache_type",
    "filesystem"
  )

  if cache != false && type != "memory"
    self.cache = begin
      Sprockets::Cache::FileStore.new(
        jekyll.in_source_dir(
          cache
        )
      )
    end

  elsif cache && type == "memory"
    self.cache = begin
      Sprockets::Cache::MemoryStore.new
    end

  else
    Jekyll.logger.info "", "Caching is disabled by configuration. " \
      "However, if you're using proxies, a cache might still be created."
  end
end
