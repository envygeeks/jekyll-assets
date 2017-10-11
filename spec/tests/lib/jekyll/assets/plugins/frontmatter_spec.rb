# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Frontmatter" do
  let :asset do
    env.manifest.find("plugins/frontmatter").first
  end

  describe "---" do
    it "strips frontmatter" do
      expect(asset.to_s).to(eq("body {\n  opacity: 1;\n}\n"))
    end
  end
end
