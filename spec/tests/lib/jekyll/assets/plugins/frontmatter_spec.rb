# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"
describe "Plugins/Frontmatter" do
  let :asset do
    env.find_asset!("plugins/frontmatter")
  end

  describe "---" do
    it "strips frontmatter" do
      expect(asset.to_s).to(match(/^body\s*{/))
    end
  end
end
