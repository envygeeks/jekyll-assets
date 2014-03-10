require "compass"
require "sprockets"

Compass::Frameworks::ALL.each do |fw|
  path = fw.stylesheets_directory
  Sprockets.append_path path if path
end
