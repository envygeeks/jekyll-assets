require "rspec/helper"

describe "css-auto-prefixing" do
  let :site do
    stub_jekyll_site
  end

  let :env do
    site.sprockets
  end

  before do
    site.\
    process
  end

  it "prefixes css" do
    result = env.find_asset("prefix.css").to_s
    expect(result).to match %r!-webkit-order:\s+1!
    expect(result).to match %r!-ms-flex-order:\s+1!
  end
end
