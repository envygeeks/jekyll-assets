require "rspec/helper"
describe Jekyll::Assets::Tag::Parser do
  let :tag do
    %Q{hello.jpg lol magick:2x sprockets:accept:image/gif key:value magick:format:png}
  end

  it "properly parses syntax" do
    expect(described_class.new(tag, "img").args).to match({
      :file=>"hello.jpg",

      :sprockets=>{
        :accept=>"image/gif"
      },

      :html=>{
        "lol"=>true,
        "key"=>"value"
      },

      :magick=>{
        :format=>"png",
        :"2x" => true
      }
    })
  end

  it "raises a proxy error if the proxy argument is invalid" do
    expect { described_class.new("img.jpg sprockets:unknown:argument", "img") }.to(
      raise_error(
        Jekyll::Assets::Tag::Parser::UnknownProxyError
      )
    )
  end

  it "raises unescaped colon error if colons aren't escaped" do
    expect { described_class.new("img.jpg unknown:argument:raises", "img") }.to(
      raise_error(
        Jekyll::Assets::Tag::Parser::UnescapedDoubleColonError
      )
    )
  end

  it "does not assume an argument is proxy if it's boolean HTML" do
    result = described_class.new("img.jpg sprockets:unknown", "img").args
    expect(result[:html]).to match({
      "sprockets" => "unknown"
    })
  end

  it "allows escaping the colon" do
    v = described_class.new("hello.jpg sprockets:accept:image\\\\:gif", "img").args
    expect(v[:sprockets][:accept]).to eq(
      "image:gif"
    )
  end

  it "works with escaping in quotes" do
    v = described_class.new('hello.jpg sprockets:accept:"image\\\:gif"', "img").args
    expect(v[:sprockets][:accept]).to eq(
      "image:gif"
    )
  end

  context "with quoting" do
    it "works with complete arg quoting" do
      v = described_class.new("hello.jpg 'sprockets:accept:image/gif'", "img").args
      expect(v[:sprockets][:accept]).to eq(
        "image/gif"
      )
    end

    it "works with partial arg quoting" do
      v = described_class.new("hello.jpg sprockets:accept:'image/gif'", "img").args
      expect(v[:sprockets][:accept]).to eq(
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
