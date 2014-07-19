require "sprockets"

gemspec = Gem::Specification.find_by_name "bootstrap-sass"
subpath = Gem::Version.new("3.2") <= gemspec.version ? "" : "vendor"

%w[images fonts javascripts stylesheets].each do |asset|
  Sprockets.append_path File.join(gemspec.gem_dir, subpath, "assets", asset)
end
