require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Tag do
  let( :uncached_env) { Jekyll::Assets::Env.new(uncached_site) }
  let(:path) { uncached_site.in_dest_dir("/assets") }
  let(:uncached_site) { stub_jekyll_site }
  before :each, :process => true do
    uncached_site.process
  end

  def fragment(html)
    Nokogiri::HTML.fragment(html)
  end

  it "uses tags and returns the HTML", :process => true do
    expect(fragment(uncached_site.pages.first.to_s).xpath( \
      "p//img[contains(@alt, 'filter')]").size).to eq 1
  end
end
