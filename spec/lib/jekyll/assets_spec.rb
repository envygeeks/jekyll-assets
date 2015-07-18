require "jekyll/assets"

describe Jekyll::Assets do
  it "doesn't digest assets when not told to" do
    path = File.expand_path("../../../fixture/_site/assets/bundle.*", __FILE__)
    stub_jekyll_site_with_processing({
      "assets" => {
        "digest" => false
      }
    })

    Dir[path].each do |v|
      expect(File.basename(v)).to match(
        %r!\Abundle\.(css|js)\Z!
      )
    end
  end

  it "digests assets when told to" do
    path = File.expand_path("../../../fixture/_site/assets/bundle-*", __FILE__)
    stub_jekyll_site_with_processing({
      "assets" => {
        "digest" => true
      }
    })

    Dir[path].each do |v|
      expect(File.basename(v)).to match(
        %r!\Abundle-([a-zA-Z0-9]+)\.(css|js)\Z!
      )
    end
  end

  it "writes user supplied assets" do
    path = File.expand_path("../../../fixture/_site/assets/*.jpg", __FILE__)
    stub_jekyll_site_with_processing({
      "assets" => {
        "assets" => [
          "*.jpg"
        ]
      }
    })

    expect(Dir[path].size).to eq(
      1
    )
  end
end
