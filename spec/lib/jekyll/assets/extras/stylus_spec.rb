require "rspec/helper"

describe "stylus-precompiler" do
  it "just works" do
    site = stub_jekyll_site_with_processing
    result = site.sprockets.find_asset("stylus").to_s.gsub(/$\n\s*/, " ").strip
    expect(result).to match %r!\-webkit-order:\s!
    expect(result).to match %r!\Abody \{!
  end

  context :options do
    it "allows compression" do
      site = stub_jekyll_site_with_processing("assets" => {
        "engines" => {
          "stylus" => {
            "compress" => true
          }
        }
      })

      expect(site.sprockets.find_asset("stylus")).not_to match(
        %r!\s!
      )
    end
  end
end
