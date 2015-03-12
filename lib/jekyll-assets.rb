# rubocop: disable FileName
require "jekyll/assets"

Dir[File.dirname(__FILE__) + "/jekyll-assets/*.rb"].each do |file|
  require file
end
