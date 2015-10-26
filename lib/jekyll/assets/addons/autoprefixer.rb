try_require_if_javascript "autoprefixer-rails" do
  Jekyll::Assets::Hook.register :env, :init do |env|
    AutoprefixerRails.install(env)
  end
end
