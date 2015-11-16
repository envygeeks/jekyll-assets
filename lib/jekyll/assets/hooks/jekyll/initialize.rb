Jekyll::Hooks.register :site, :post_read do |jekyll|
  Jekyll::Assets::Env.new(jekyll)
end
