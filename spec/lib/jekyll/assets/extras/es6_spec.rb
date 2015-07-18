require "rspec/helper"

describe "transpiling-es6" do
  let :site do
    stub_jekyll_site_with_processing
  end

  let :env do
    site.sprockets
  end

  it "transpiles es6" do
    expect(env.find_asset("transpile.js").to_s.strip.gsub(/$\n+/, " ")).to eq(
      %Q{"use strict"; var Hello = Symbol();}
    )
  end
end
