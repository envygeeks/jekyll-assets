require "rspec/helper"

describe "font-awesome" do
  let( :env) { Jekyll::Assets::Env.new(site) }
  let(:site) { stub_jekyll_site }

  it "makes font-awesome available" do
    expect(env.find_asset("font-awesome").to_s).to match( \
      /fa-.+:before\s+{/)
  end
end
