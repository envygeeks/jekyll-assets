# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Addons::Processors::Liquid do
  let(:env) do
    Jekyll::Assets::Env.new(stub_jekyll_site)
  end

  it "lets the user use Liquid" do
    source = env.find_asset("liquid").to_s
    expect(source).not_to(match(/\{{2}\s*site\.background_image\s*\}{2}/))
    expect(source).to(match(/background:\s*url\("\/assets\/ruby\.png"\)/))
  end
end
