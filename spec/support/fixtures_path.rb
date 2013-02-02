require "pathname"


module Jekyll::AssetsPlugin
  module RSpecHelpers
    extend self

    def fixtures_path
      @fixtures_path ||= Pathname.new(__FILE__).parent.parent.join("fixtures")
    end
  end
end
