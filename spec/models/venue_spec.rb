require 'spec_helper'

describe Venue do
  it "should add a venue if the venue does not exist and return true" do
    added, venue = Venue.add_if_not_exists("name", 42, "address1", "address2", "city","postcode",1.56,0.43)
    added.should be_true
    venue.external_id.should == 42
  end

  it "should not add a venue if the venue exists based on external id" do
    Venue.create!(:name=> "name", :external_id => 42)
    added, venue = Venue.add_if_not_exists("name", 42, "address1", "address2", "city","postcode",1.56,0.43)
    added.should be_false
    venue.external_id.should == 42
  end
end
