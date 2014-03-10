require "sprockets"

bourbon_root = Gem::Specification.find_by_name("bourbon").gem_dir
Sprockets.append_path File.join(bourbon_root, "app", "assets", "stylesheets")
