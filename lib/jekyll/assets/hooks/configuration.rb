# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init, :early do
  jekyll.config["assets"] = Jekyll::Assets::Config.merge(asset_config)
  Jekyll::Assets::Config.merge_sources(
    jekyll, asset_config
  )
end
