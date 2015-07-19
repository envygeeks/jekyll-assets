Jekyll::Assets::Helpers.try_require_if_javascript? "stylus/sprockets" do
  Jekyll::Assets::Hook.register :env, :post_init do |e|
    opts = e.asset_config.fetch("engines", {}).fetch("stylus", {}).dup
    opts = Jekyll::Assets::Whitelist.new([:compress], opts).process
    Stylus.setup(
      e, opts
    )
  end
end
