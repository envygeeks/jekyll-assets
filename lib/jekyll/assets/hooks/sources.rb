# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  asset_config["sources"] ||= []

  asset_config["sources"].each do |v|
    append_path jekyll.in_source_dir(v)
  end
end
