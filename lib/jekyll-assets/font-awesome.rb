require "sprockets"

fa = Gem::Specification.find_by_name("font-awesome-sass").gem_dir
%w[fonts stylesheets].each do |asset|
  Sprockets.append_path File.join(fa, "vendor", "assets", asset)
end
