require "sprockets"

gemspec = Gem::Specification.find_by_name "font-awesome-sass"
subpath = Gem::Version.new("4.2") <= gemspec.version ? "" : "vendor"

%w[fonts stylesheets].each do |asset|
  Sprockets.append_path File.join(gemspec.gem_dir, subpath, "assets", asset)
end
