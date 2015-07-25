require "rspec/helper"
describe Jekyll::Assets::Tag::Parser do
  let(:escape_error) { Jekyll::Assets::Tag::Parser::UnescapedColonError }
  let( :proxy_error) { Jekyll::Assets::Tag::Parser::UnknownProxyError }
  let(       :klass) { described_class }

  it "properly parses syntax" do
    input = "hello.jpg lol magick:2x sprockets:accept:image/gif " \
      "key:value magick:format:png"

    expect(described_class.new(input, "img").args).to match({
      :file=>"hello.jpg",

      :sprockets => {
        :accept=>"image/gif"
      },

      :html => {
        "lol"=>true,
        "key"=>"value"
      },

      :magick => {
        :format=>"png",
        :"2x" => true
      }
    })
  end

  it "raises an error if there is no proxy available" do
    input = "img.jpg sprockets:unknown:hello"
    expect { klass.new(input, "img") }.to raise_error \
      Jekyll::Assets::Tag::Parser::UnknownProxyError
  end

  it "makes like 'proxy' argument an HTML argument if there is no proxy key" do
    input = "img.jpg sprockets:unknown"
    expect(klass.new(input, "img").args[:html]["sprockets"]).to eq \
      "unknown"
  end

  it "allows boolean proxy arguments" do
    input = "img.jpg magick:2x"
    expect(klass.new(input, "img").args[:magick][:"2x"]).to eq \
      true
  end

  it "does not allocate boolean arguments as proxy values" do
    input = "img.jpg magick:2x:raise"
    expect { klass.new(input, "img") }.to raise_error \
      proxy_error
  end

  it "expects escaping more than one colon with quotes" do
    input = "hello.jpg sprockets:accept:'image:gif'"
    expect { klass.new(input, "img") }.to raise_error \
      escape_error
  end

  it "expects escaping more than one colon without quotes" do
    input = "hello.jpg sprockets:acpet:image:gif"
    expect { klass.new(input, "img") }.to raise_error \
      escape_error
  end

  it "allows escaping inside of quotes" do
    input = 'hello.jpg sprockets:accept:"image\\\:gif"'
    expect(klass.new(input, "img")[:sprockets][:accept]).to eq \
      "image:gif"
  end

  it "allows quoting the entire argument" do
    input = "hello.jpg 'sprockets:accept:image/gif'"
    expect(klass.new(input, "img").args[:sprockets][:accept]).to eq \
      "image/gif"
  end

  it "allows quoting only fragments of an argument" do
    input = "hello.jpg sprockets:accept:'image/gif'"
    expect(klass.new(input, "img").args[:sprockets][:accept]).to eq \
      "image/gif"
  end
end
