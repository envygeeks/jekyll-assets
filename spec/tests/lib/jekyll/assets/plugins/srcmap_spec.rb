# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Jekyll::Assets::Plugins::SrcMap" do
  subject do
    Jekyll::Assets::Plugins::SrcMap
  end

  #

  let :asset do
    env.find_asset!("bundle.css")
  end

  #

  describe "#map_path" do
    it "returns <String>path" do
      expect(subject.map_path(env: env, asset: asset)).to \
        start_with(subject::DIR_NAME)
    end
  end

  #

  describe "#path" do
    it "returns <Pathutil>" do
      expect(subject.path(env: env, asset: asset)).to \
        be_a(Pathutil)
    end
  end
end
