require_relative "../env"

Jekyll::Hooks.register :site, :post_read do |s|
  env = Jekyll::Assets::Env.new(s)
  Sprockets::Helpers.configure do |c|
    c.digest   = env.digest?
    c.prefix   = env.asset_config.fetch(
      "prefix", "/assets"
    )
  end
end
