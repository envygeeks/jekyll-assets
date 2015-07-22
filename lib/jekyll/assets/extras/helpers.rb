Jekyll::Assets::Hook.register :env, :post_init do |e|
  Sprockets::Helpers.configure do |c|
    c.prefix   = e.prefix_path
    c.digest   = e.digest?
  end
end
