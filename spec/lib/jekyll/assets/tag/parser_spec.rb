require "rspec/helper"
describe Jekyll::Assets::Tag::Parser do
  it "properly parses syntax" do
    v = described_class.new("hello.jpg @2x lol world accept:image/gif key:value", \
      "img").instance_variable_get(:@args)

    expect(v[:proxy]).to eq({ :accept => "image/gif" })
    expect(v[:other]).to eq({ "key" => "value" })
    expect(v[:args ]).to include "@2x"
    expect(v[:args ]).to include "world"
    expect(v[:args ]).to include "lol"
  end

  it "allows escaping the colon" do
    v = described_class.new("hello.jpg accept:image\\\\:gif", "img"). \
      instance_variable_get(:@args)

    expect(v[:proxy][:accept]).to eq(
      "image:gif"
    )
  end

  it "works with escaping in quotes" do
    v = described_class.new('hello.jpg accept:"image\\\:gif"', "img"). \
      instance_variable_get(:@args)

    expect(v[:proxy][:accept]).to eq(
      "image:gif"
    )
  end

  context "with quoting" do
    it "works with complete arg quoting" do
      v = described_class.new("hello.jpg 'accept:image/gif'", "img"). \
        instance_variable_get(:@args)

      expect(v[:proxy][:accept]).to eq(
        "image/gif"
      )
    end

    it "works with partial arg quoting" do
      v = described_class.new("hello.jpg accept:'image/gif'", "img"). \
        instance_variable_get(:@args)

      expect(v[:proxy][:accept]).to eq(
        "image/gif"
      )
    end
  end

  it "converts arguments we don't want into html arguments" do
    v = described_class.new("hello.jpg hello:world how:are you:today", "img")
    v = v.to_html.split(" ")
    expect(v.size).to eq 3
    expect(v).to include 'hello="world"'
    expect(v).to include 'how="are"'
    expect(v).to include 'you="today"'
  end
end
