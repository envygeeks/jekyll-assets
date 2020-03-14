# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Jekyll::Assets::Plugins::SrcMap::CSS" do
  subject do
    env.find_asset!("bundle.css").to_s
  end

  #

  it "generates" do
    expect(subject).to match(%r!/*# sourceMappingURL=!)
    expect(subject).to match(%r!/*# sourceURL=!)
  end
end
