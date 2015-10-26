Jekyll::Hooks.register :site, :post_write do |jekyll|
  jekyll.sprockets.write_all
end
