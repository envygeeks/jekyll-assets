Jekyll::Assets::Hook.register :env, :init do
  jekyll.sprockets = self
end
