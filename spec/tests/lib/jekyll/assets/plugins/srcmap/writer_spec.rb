# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Jekyll::Assets::Plugins::SrcMap::Writer" do
  subject do
    env.find_asset!("bundle.css")
  end

  #

  it "writes" do
    b = subject.to_s.match(%r!/*# sourceURL=([^\s]+).+/!)
    a = subject.to_s.match(%r!/*# sourceMappingURL=([^\s]+).+/!)
    expect(Pathutil.new(jekyll.in_dest_dir(a[1]))).to exist
    b = Jekyll::Assets::Plugins::SrcMap.path(env: env, asset: b[1])
    expect(Pathutil.new(env.in_dest_dir).join(b))
      .to exist
  end
end
