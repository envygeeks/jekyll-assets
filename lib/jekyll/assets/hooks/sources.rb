Jekyll::Assets::Hook.register :env, :init do
  asset_config.fetch("sources", []).each do |path|
    append_path jekyll.in_source_dir(path)
  end
end
