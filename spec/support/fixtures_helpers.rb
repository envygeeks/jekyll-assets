require "pathname"

module FixturesHelpers
  def fixtures_path
    @fixtures_path ||= Pathname.new(__FILE__).parent.parent.join("fixtures")
  end
end
