Jekyll::Hooks.register :site, :post_read do |s|
  Jekyll::Assets::Hook.trigger(
    :env, :post_init, Jekyll::Assets::Env.new(s)
  )
end
