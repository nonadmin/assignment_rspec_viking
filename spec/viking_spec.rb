require 'viking'

describe "Viking class" do
  let(:test_viking) { Viking.new("Leah", 120) }

  describe "#initialize" do
    it "allows a name attribute to be set" do
      expect( test_viking.name ).to eq("Leah")
    end

    it "allows a health attribute to be set" do
      expect( test_viking.health ).to eq(120)
    end

    it "does not allow health to be overwritten once its been set" do
      expect{ test_viking.health = 200 }.to raise_error(NoMethodError)
    end
  end

  describe "weapon methods" do
    it "a viking starts out without a weapon" do
      expect( test_viking.weapon ).to be_nil
    end

    it "#pick_up_weapon(weapon) sets the viking's weapon" do
      # Would double Bow here, but can't fake class type to pass is_a?
      test_viking.pick_up_weapon(Bow.new)
      expect( test_viking.weapon ).to be_a(Bow)
    end

    it "#pick_up_weapon(weapon) raises an error if picking up a non-weapon" do
      expect{ test_viking.pick_up_weapon("Sheep") }.to raise_error("Can't pick up that thing")
    end

    it "#pick_up_weapon(weapon) replaces any existing weapon the viking has" do
      test_viking.pick_up_weapon(Bow.new)
      test_viking.pick_up_weapon(Axe.new)
      expect( test_viking.weapon ).to be_a(Axe)
    end

    it "#drop_weapon leaves the viking without a weapon" do
      test_viking.pick_up_weapon(Bow.new)
      test_viking.drop_weapon
      expect( test_viking.weapon ).to be_nil      
    end
  end

  describe "attacking methods" do
    let(:another_viking) { Viking.new("Dixie", 100, 10, (Axe.new)) }
    let(:fake_viking) { double(:name => nil, :receive_attack => nil) }

    it "#receive_attack(damage_dealt) reduces the viking's health by the given amount" do
      allow( test_viking ).to receive(:puts)
      test_viking.receive_attack(10)
      expect( test_viking.health ).to eq(110)
    end

    it "#receive_attack(damage_dealt) calls the #take_damage(damage) method" do
      allow( test_viking ).to receive(:puts)
      expect( test_viking ).to receive(:take_damage).with(10)
      test_viking.receive_attack(10)
    end

    it "#attack(target) causes the target's health to drop" do
      allow( test_viking ).to receive(:puts)
      allow( another_viking ).to receive(:puts)
      allow( test_viking ).to receive(:damage_dealt).and_return(10)
      test_viking.attack(another_viking)
      expect( another_viking.health ).to eq(90)
    end

    it "#attack(target) calls the target's #take_damage(damage) method" do
      allow( test_viking ).to receive(:puts)
      allow( another_viking ).to receive(:puts)
      expect( another_viking ).to receive(:take_damage)
      test_viking.attack(another_viking)
    end

    it "#attack(target) with no weapon runs damage_with_fists" do
      allow( test_viking ).to receive(:puts)
      expect( test_viking ).to receive(:damage_with_fists).and_return(2.5)      
      test_viking.attack(fake_viking)
    end

    it "#attack(target) with no weapon deals Fist's multiplier times strength in damage" do
      allow( test_viking ).to receive(:puts)
      damage_amount = test_viking.strength * Fists.new.use
      expect( fake_viking ).to receive(:receive_attack).with(damage_amount)
      test_viking.attack(fake_viking)
    end

    it "#attack(target) with a weapon runs damage_with_weapon" do
      allow( another_viking ).to receive(:puts)
      expect( another_viking ).to receive(:damage_with_weapon).and_return(10)      
      another_viking.attack(fake_viking)      
    end

    it "#attack(target) with a weapon deal's that weapon's multiplier" do
      allow( another_viking ).to receive(:puts)
      damage_amount = another_viking.strength * Axe.new.use
      expect( fake_viking ).to receive(:receive_attack).with(damage_amount)
      another_viking.attack(fake_viking)
    end

    it "#attack(target) using a bow with no arrows attacks with fists instead" do
      empty_bow = Bow.new(0)
      bow_viking = Viking.new("Gus", 100, 10, empty_bow)
      expect( bow_viking ).to receive(:damage_with_fists)
      bow_viking.attack(fake_viking)
    end

    it "#receive_attack(damage_dealt) will raise an error if its kills a viking" do
      sickly_viking = Viking.new("Sickly", 1)
      expect{ sickly_viking.receive_attack(10) }.to raise_error("Sickly has Died...")
    end
  end
  
end