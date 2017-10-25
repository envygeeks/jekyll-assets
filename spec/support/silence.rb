RSpec.configure do |c|
  c.before :each do
    allow(Jekyll.logger.writer).to(receive(:logdevice))
      .and_return(StringIO.new)
  end
end
