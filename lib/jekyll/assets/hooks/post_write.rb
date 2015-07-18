Jekyll::Hooks.register :site, :post_write do |s|
  s.sprockets.write_all
end
