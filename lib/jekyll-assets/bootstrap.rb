require "sprockets"

gemspec = Gem::Specification.find_by_name "bootstrap-sass"
%w[fonts javascripts stylesheets].each do |asset|
  if Gem::Version.new("3.2") <= gemspec.version
    Sprockets.append_path File.join(gemspec.gem_dir, "assets", asset)
  else
    Sprockets.append_path File.join(gemspec.gem_dir, "vendor", "assets", asset)
  end
end
