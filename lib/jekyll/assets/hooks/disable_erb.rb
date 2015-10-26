Jekyll::Assets::Hook.register :env, :init, :early do
  self.config = hash_reassoc(config, :engines) do |hash|
    hash.delete(".erb")
    hash
  end
end
