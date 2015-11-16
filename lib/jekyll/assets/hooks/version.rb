Jekyll::Assets::Hook.register :env, :init do
  self.version = Digest::MD5.hexdigest(asset_config.inspect)
end
