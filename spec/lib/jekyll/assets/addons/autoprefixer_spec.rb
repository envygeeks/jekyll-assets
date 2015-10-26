require "rspec/helper"

describe "css auto-prefixing" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "prefixes css" do
    result = env.find_asset("prefix.css").to_s
    expect(result).to match %r!-webkit-order:\s+1!
    expect(result).to match %r!-ms-flex-order:\s+1!
  end
end
