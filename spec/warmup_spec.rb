require "warmup.rb"

describe "Warmup Class" do
  let(:warm) { Warmup.new }
  let(:test_string) { "teststring" }

  it "#gets_shout gets a string and upcase it" do
    allow(warm).to receive(:gets).and_return("hello")
    allow(warm).to receive(:puts)
    expect( warm.gets_shout ).to eq("HELLO")
  end

  it "#triple_size(array) triples the size of an object" do
    fake_array = double(:size => 5)
    expect( warm.triple_size(fake_array) ).to eq(15)
  end

  it "#calls_some_methods(string) calls upcase on the string" do
    expect( test_string ).to receive(:upcase!).and_return("str")
    warm.calls_some_methods(test_string) 
  end

  it "#calls_some_methods(string) calls reverse on the string" do
    expect( test_string ).to receive(:reverse!)
    warm.calls_some_methods(test_string)
  end

  it "#calls_some_methods(string) returns an unrelated string" do
    expect( warm.calls_some_methods( test_string ) ).not_to eq( test_string )
  end
end