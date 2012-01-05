require 'spec_helper'

describe 'Cards' do
  
  before(:all) do
    User.create(:email => 'tester@fadedpixels.net', :username => 'tester', :password => 'notecard', :password_confirmation => 'notecard')
  end

  it "should require an entry" do
    Card.create(:user_id => 1, :month => 1, :day => 1, :year => 2000).should_not be_valid
    Card.create(:user_id => 1, :month => 1, :day => 1, :year => 2000, :entry => "Testing").should be_valid
  end

  it "should require an entry shorter than 365 chars" do
    Card.create(:user_id => 1, :month => 2, :day => 1, :year => 2000, :entry => SecureRandom.random_bytes(366)).should_not be_valid
    Card.create(:user_id => 1, :month => 2, :day => 1, :year => 2000, :entry => SecureRandom.random_bytes(365)).should be_valid
    Card.create(:user_id => 1, :month => 2, :day => 2, :year => 2000, :entry => SecureRandom.random_bytes(1)).should be_valid
  end

  it "should require a day" do
    Card.create(:user_id => 1, :month => 3, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :day => 3, :month => 1, :year => 2000, :entry => "Testing").should be_valid
  end

  it "should require a day between 1-31" do
    Card.create(:user_id => 1, :month => 4, :day => 0, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :month => 4, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:user_id => 1, :month => 4, :day => 31, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:user_id => 1, :month => 4, :day => 32, :year => 2000, :entry => "Testing").should_not be_valid
  end

  it "should require a month" do
    Card.create(:user_id => 1, :day => 5, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :day => 5, :month => 1, :year => 2000, :entry => "Testing").should be_valid
  end
  
  it "should require a month between 1-12" do
    Card.create(:user_id => 1, :month => 0, :day => 2, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :month => 1, :day => 2, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:user_id => 1, :month => 12, :day => 6, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:user_id => 1, :month => 13, :day => 6, :year => 2000, :entry => "Testing").should_not be_valid
  end
  
  it "should require a year" do
    Card.create(:user_id => 1, :month => 6, :day => 1, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :month => 6, :day => 1, :year => 2000, :entry => "Testing").should be_valid
  end
  
  it "should require a year in the right format" do
    Card.create(:user_id => 1, :month => 7, :day => 1, :year => 20, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :month => 7, :day => 1, :year => 2000, :entry => "Testing").should be_valid
    Card.create(:user_id => 1, :month => 7, :day => 1, :year => 1900, :entry => "Testing").should be_valid
  end

  it "should require a user" do
    Card.create(:month => 8, :day => 1, :year => 2000, :entry => "Testing").should_not be_valid
    Card.create(:user_id => 1, :month => 8, :day => 1, :year => 2000, :entry => "Testing").should be_valid
  end
end
