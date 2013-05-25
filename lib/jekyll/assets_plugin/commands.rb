# 3rd-party
require "commander"


::Commander::Runner.instance.command "assets:cleanup" do |c|
  c.syntax      = "jekyll assets:cleanup"
  c.description = "Clenup jekyll-assets cache"

  c.option "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
    "Custom Jekyll configuration file"

  c.action do |_, options|
    assets = Jekyll::Site.new(Jekyll.configuration(options)).assets
    assets.cache_path.rmtree if assets.cache_path.exist?
  end
end
