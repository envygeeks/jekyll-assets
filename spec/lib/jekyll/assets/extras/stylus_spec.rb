require "rspec/helper"

describe "stylus-precompiler" do
  let( :env) { Jekyll::Assets::Env.new(site) }
  let(:site) { stub_jekyll_site }

  it "converts stylus to css" do
    result = env.find_asset("stylus").to_s.gsub(/$\n\s*/, " ").strip
    expect(result).to match %r!\-webkit-order:\s!
    expect(result).to match %r!\Abody \{!
  end

  context "with options" do
    it "allows compression" do
      stub_asset_config "engines" => { "stylus" => { "compress" => true }}
      expect(env.find_asset("stylus")).to_not match %r!\s!
      expect(env.find_asset("stylus")).to_not eq ""
    end
  end
end
