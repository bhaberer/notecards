require 'spec_helper'

describe 'Cards' do

  it "should require an entry" do
    Card.create(:month => 1, :day => 1, :year => 2000).should_not be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
  end

  it "should require an entry shorter than 365 chars" do
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => SecureRandom.random_bytes(366)).should_not be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => SecureRandom.random_bytes(365)).should be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => SecureRandom.random_bytes(1)).should be_valid
  end

  it "should require a day" do
    Card.create(:month => 1, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:day => 1, :month => 1, :year => 2000, :entry => "Testing").should be_valid
  end

  it "should require a day between 1-31" do
    Card.create(:month => 1, :day => 0, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:month => 1, :day => 31, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:month => 1, :day => 32, :year => 2000, :entry => "Testing").should_not be_valid
  end

  it "should require a month" do
    Card.create(:day => 1, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:day => 1, :month => 1, :year => 2000, :entry => "Testing").should be_valid
  end
  
  it "should require a month between 1-12" do
    Card.create(:month => 0, :day => 1, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:month => 12, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:month => 13, :day => 1, :year => 2000, :entry => "Testing").should_not be_valid
  end
  
  it "should require a year" do
    Card.create(:month => 1, :day => 1, :entry => "Testing").should_not be_valid
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
  end
  
  it "should require a year in the right format" do
    Card.create(:month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:month => 1, :day => 1, :year => 1900, :entry => "Testing").should be_valid
    Card.create(:month => 1, :day => 1, :year => 20, :entry => "Testing").should_not be_valid
  end

  it "should require a user"

end
