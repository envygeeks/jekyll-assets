require "compass"
require "sprockets"


Compass::Frameworks::ALL.each do |fw|
  if (path = fw.stylesheets_directory)
    Sprockets.append_path path
  end
end
