Jekyll::Hooks.register :site, :post_read do |s|
  Jekyll::Assets::Env.new(s)
end
