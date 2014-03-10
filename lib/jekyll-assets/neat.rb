require "sprockets"

neat_root = Gem::Specification.find_by_name("neat").gem_dir
Sprockets.append_path File.join(neat_root, "app", "assets", "stylesheets")
