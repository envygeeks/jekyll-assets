require "pathname"

module Jekyll::AssetsPlugin
  module RSpecHelpers
    def fixtures_path
      @fixtures_path ||= Pathname.new(__FILE__).parent.parent.join("fixtures")
    end

    module_function :fixtures_path
  end
end
