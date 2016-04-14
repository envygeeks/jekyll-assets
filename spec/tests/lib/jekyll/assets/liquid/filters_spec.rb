# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Liquid::Filters do
  before :each do
    site.process
  end

  #

  let :site do
    stub_jekyll_site
  end

  #

  it "uses tags and returns the HTML" do
    expect(fragment(site.pages.first.to_s).xpath("p//img[contains(@alt, 'filter')]").size).to(
      eq 1
    )
  end
end
