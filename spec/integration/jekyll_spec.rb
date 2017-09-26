# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "JEKYLL INTEGRATION" do
  describe "Jekyll#config[exclude]" do
    subject do
      stub_jekyll_site.config[
        "exclude"
      ]
    end

    #

    it "should add the cache to the excludes" do
      expect(subject).to include(
        ".asset-cache"
      )
    end
  end
end
