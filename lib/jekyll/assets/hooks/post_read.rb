Jekyll::Hooks.register :site, :post_read do |s|
  Jekyll::Assets::Env.trigger_hooks(
    :post_init, Jekyll::Assets::Env.new(s)
  )
end
