Jekyll::Assets::Env.register_hook :post_init do |e|
  Sprockets::Helpers.configure do |c|
    c.digest   = e.digest?
    c.prefix   = e.asset_config.fetch(
      "prefix", "/assets"
    )
  end
end
