require 'weapons/bow'

describe "Bow class, subclass of weapon" do
  let(:test_bow) { Bow.new }

  it "should have a readable arrow count" do
    expect( test_bow ).to respond_to(:arrows)
  end

  it "should be created with 10 arrows by default" do
    expect( test_bow.arrows ).to eq(10)
  end

  it "can be created with a specific number of arrows" do
    more_arrows = Bow.new(20)
    expect( more_arrows.arrows ).to eq(20)
  end

  it "#use should reduce arrow count by one" do
    allow(test_bow).to receive(:puts)
    test_bow.use
    expect( test_bow.arrows ).to eq(9)
  end

  it "#use should throw an error if there is no arrows" do
    no_more_arrows = Bow.new(0)
    expect { no_more_arrows.use }.to raise_error("Out of arrows")
  end
end