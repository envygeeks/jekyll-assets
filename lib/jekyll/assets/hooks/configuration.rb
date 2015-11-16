# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init, :early do
  jekyll.config.store("assets", Jekyll::Assets::Config.merge(asset_config))
end
