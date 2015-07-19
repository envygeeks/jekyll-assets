require "rspec/helper"
describe Jekyll::Assets::Whitelist do
  it "only accepts arguments on the whitelist" do
    result = described_class.new(%W(hello), { "hello" => 1, "world" => 2 }).process
    expect(result).to match({
      "hello" => 1
    })
  end

  it "works with symbols" do
    result = described_class.new(["hello", :world], { "hello" => 1, \
        :world => 2, "hey" => 3 }).process

    expect(result).to match({
      "hello" => 1,
      :world  => 2
    })
  end
end
