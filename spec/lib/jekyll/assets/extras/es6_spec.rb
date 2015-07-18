require "rspec/helper"

describe "transpiling-es6" do
  let :site do
    stub_jekyll_site
  end

  let :env do
    Jekyll::Assets::Env.new(
      site
    )
  end

  it "transpiles es6" do
    expect(env.find_asset("transpile.js").to_s.strip.gsub(/$\n+/, " ")).to eq(
      %Q{"use strict"; var Hello = Symbol();}
    )
  end
end
