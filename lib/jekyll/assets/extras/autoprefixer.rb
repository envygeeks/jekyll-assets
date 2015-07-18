Jekyll::Assets::Helpers.try_require_if_javascript? "autoprefixer-rails" do
  Jekyll::Assets::Env.register_hook :post_init do |e|
    AutoprefixerRails.install(
      e
    )
  end
end
