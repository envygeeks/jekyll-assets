require "sprockets"

bitters_root = Gem::Specification.find_by_name("bitters").gem_dir
Sprockets.append_path File.join(bitters_root, "app", "assets", "stylesheets")
