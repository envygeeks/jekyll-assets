Jekyll::Hooks.register :site, :after_reset do |jekyll|
  unless jekyll.config["exclude"].grep(/\A\.asset\-cache\/?/)
    jekyll.config["exclude"].push(".asset-cache/")
  end
end
