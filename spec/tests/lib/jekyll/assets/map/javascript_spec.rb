# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Jekyll::Assets::Map::JavaScript", sprockets: 4 do
  subject do
    env.find_asset!("bundle.js").to_s
  end

  #

  it "generates" do
    expect(subject).to match(%r!//# sourceMappingURL=!)
    expect(subject).to match(%r!//# sourceURL=!)
  end
end
