require "rspec/helper"
describe Jekyll::Assets::Tag::Parser do
  let :tag do
    %Q{hello.jpg lol accept:image/gif key:value convert:png}
  end

  it "properly parses syntax" do
    v = described_class.new(tag, "img").instance_variable_get(:@args)
    expect(v).to match({
      :file  => "hello.jpg",

      :proxy => {
        :find => {
          :accept => "image/gif"
        },

        :write => {
          "convert" => "png"
        }
      },

      :other => {
        "lol" => true, "key" => "value"
      }
    })
  end

  it "allows escaping the colon" do
    v = described_class.new("hello.jpg accept:image\\\\:gif", "img"). \
      instance_variable_get(:@args)

    expect(v[:proxy][:find][:accept]).to eq(
      "image:gif"
    )
  end

  it "works with escaping in quotes" do
    v = described_class.new('hello.jpg accept:"image\\\:gif"', "img"). \
      instance_variable_get(:@args)

    expect(v[:proxy][:find][:accept]).to eq(
      "image:gif"
    )
  end

  context "with quoting" do
    it "works with complete arg quoting" do
      v = described_class.new("hello.jpg 'accept:image/gif'", "img"). \
        instance_variable_get(:@args)

      expect(v[:proxy][:find][:accept]).to eq(
        "image/gif"
      )
    end

    it "works with partial arg quoting" do
      v = described_class.new("hello.jpg accept:'image/gif'", "img"). \
        instance_variable_get(:@args)

      expect(v[:proxy][:find][:accept]).to eq(
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
