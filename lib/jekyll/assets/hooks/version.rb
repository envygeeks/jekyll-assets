Jekyll::Assets::Hook.register :env, :init do
  self.version = Digest::MD5.hexdigest(jekyll.config.fetch("assets", {}).inspect)
end
