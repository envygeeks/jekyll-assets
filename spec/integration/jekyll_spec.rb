# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "JEKYLL INTEGRATION" do
  describe "Jekyll#config[exclude]" do
    subject { stub_jekyll_site.config["exclude"] }
    it { is_expected.to include ".asset-cache" }
    Jekyll::Assets::Config::DefaultSources.each do |source|
      it { is_expected.to include source }
    end
  end
end
