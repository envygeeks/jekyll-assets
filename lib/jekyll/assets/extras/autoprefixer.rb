Jekyll::Assets::Helpers.try_require_if_javascript? "autoprefixer-rails" do
  Jekyll::Assets::Hook.register :env, :post_init do |e|
    AutoprefixerRails.install(e)
  end
end
