require "sprockets"

gemspec = Gem::Specification.find_by_name "bootstrap-sass"

%w(images fonts javascripts stylesheets).each do |asset|
  Sprockets.append_path File.join(gemspec.gem_dir, "assets", asset)
end
