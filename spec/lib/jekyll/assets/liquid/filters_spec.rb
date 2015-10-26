require "rspec/helper"

describe Jekyll::Assets::Liquid::Filters do
  before(:each) { site.process }; let(:site) { stub_jekyll_site }
  it "uses tags and returns the HTML" do
    expect(fragment(site.pages.first.to_s).xpath( \
      "p//img[contains(@alt, 'filter')]").size).to eq 1
  end
end
