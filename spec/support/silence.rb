# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

RSpec.configure do |c|
  c.before :each do
    allow(Jekyll.logger.writer).to(receive(:logdevice))
      .and_return(StringIO.new)
  end
end
