# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Jekyll::Assets::Map", sprockets: 4 do
  subject do
    Jekyll::Assets::Map
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
