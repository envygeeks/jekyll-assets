require "rspec/helper"

describe "transpiling-es6" do
  let( :env) { Jekyll::Assets::Env.new(site) }
  let(:site) { stub_jekyll_site }

  it "transpiles es6" do
    expect(env.find_asset("transpile.js").to_s.strip.gsub(/$\n+/, " ")).to eq \
      %Q{"use strict"; var Hello = Symbol();}
  end
end
