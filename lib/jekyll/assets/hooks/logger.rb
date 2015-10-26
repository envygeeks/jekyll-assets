Jekyll::Assets::Hook.register :env, :init do
  self.logger = Jekyll::Assets::Logger.new
end
