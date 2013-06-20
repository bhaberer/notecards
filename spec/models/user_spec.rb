require 'spec_helper'

describe User do
  before(:each) do
    User.all.each.map(&:destroy)
  end

  it 'should require users to pick a username' do
    FactoryGirl.build(:user, :username => nil).
      should_not be_valid
  end

  describe :cards_for_day do
    before(:each) do
      @user = FactoryGirl.create(:user)
      (1..8).each do |n|
        FactoryGirl.create(:card, :user => @user, :day => 1, :month => 1, :year => "200#{n}")
      end
    end

    it 'should return all of a users cards for a given day and month' do
      @user.cards_for_day(1, 1).count.
        should == 8
      FactoryGirl.create(:card, :user => @user, :day => 1, :month => 2)
      @user.cards_for_day(2, 1).count.
        should == 1
    end

    it 'should not return cards for dates that have no cards' do
      @user.cards_for_day(2, 1).count.
        should == 0
    end

    it 'should not return cards for invalid dates' do
      @user.cards_for_day('bl', :w).count.
        should == 0
    end
  end

  describe :cards_for_month do
    before(:each) do
      @user = FactoryGirl.create(:user)
      [[2,3], [2,4], [3,2], [3,10], [3,1]].each do |d|
        FactoryGirl.create(:card, :user => @user, :month => d[0], :day => d[1])
      end
    end

    it 'should return all of a users cards for a given month' do
      @user.cards_for_month(3).count.should == 3
      @user.cards_for_month(2).count.should == 2
    end

    it 'should not return cards for months without cards' do
      @user.cards_for_month(1).count.should == 0
    end

    it 'should not return cards for invalid dates' do
      @user.cards_for_month(:foo).count.should == 0
    end
  end

  describe :cards_for_year do
    before(:each) do
      @user = FactoryGirl.create(:user)
      [[2,3], [2,4], [3,2], [3,10], [3,1]].each do |d|
        FactoryGirl.create(:card, :user => @user, :day => d[1], :year => "200#{d[0]}")
      end
    end

    it 'should return all of a users cards for a given year' do
      @user.cards_for_year(2002).count.should == 2
      @user.cards_for_year(2003).count.should == 3
    end

    it 'should not return cards for months without cards' do
      @user.cards_for_year(2001).count.should == 0
    end

    it 'should not return cards for invalid dates' do
      @user.cards_for_year(:foo).count.should == 0
    end
  end

  describe :card_for_date do
    before(:each) do
      @user = FactoryGirl.create(:user)
      (1..8).each do |n|
        FactoryGirl.create(:card, :user => @user, :day => 1, :month => 2, :year => "200#{n}")
      end
    end

    it 'should return the card for the year specified if it exists' do
      @user.card_for_date(Time.parse('Feb 1 2001')).
        should_not be_nil
    end

    it 'should not return cards when there was no entry for that day' do
      @user.card_for_date(Time.parse('Feb 1 2000')).
        should be_nil
    end

    it 'should return nothing on an invalid date' do
      @user.card_for_date('Feb 1 2000').
        should be_empty
    end
  end

  describe :admins do
    it 'should return nothing if no admins are present' do
      User.admins.should be_blank
    end

    it 'should return any users who are admins' do
      user = FactoryGirl.create(:user, :admin => true)
      User.admins.should == [user]
    end

    it 'should only return users who are admins' do
      FactoryGirl.create(:user, :admin => true)
      FactoryGirl.create(:user, :email => 'boo@sdasd.com')
      User.all.length.should == 2
      User.admins.length.should == 1
    end
  end

  describe :gravatar do
    it 'should return a avatar link given a user' do
      FactoryGirl.create(:user).gravatar.
        should == 'http://gravatar.com/avatar/6fc2bfa8514fbacb2b1ccceeca22f372.png?s=48&d=identicon'
    end

    it 'should allow you to set an optional size for the avatar' do
      FactoryGirl.create(:user).gravatar(10).
        should == 'http://gravatar.com/avatar/6fc2bfa8514fbacb2b1ccceeca22f372.png?s=10&d=identicon'
    end
  end

  describe :last_entries do
    before(:each) do
      @user = FactoryGirl.create(:user, :admin => true)
    end

    it 'should return only 10 cards for a user' do
      (1..20).each { |d| FactoryGirl.create(:card, :user => @user, :day => d) }
      @user.last_entries.count.
        should == 10
    end

    it 'should return fewer than 10 cards if the user has not made that many' do
      (1..7).each { |d| FactoryGirl.create(:card, :user => @user, :day => d) }
      @user.last_entries.count.
        should == 7
    end

    it 'should return the 10 last entries' do
      (1..20).each { |d| FactoryGirl.create(:card, :user => @user, :day => d) }
      @user.last_entries.
        should_not include(@user.cards_for_day(1, 9).first)
    end
  end

  describe :has_done_todays_card? do
    it 'should return true if user has done todays card' do
      @user = FactoryGirl.create(:user, :admin => true)
      @time = Time.now
      FactoryGirl.create(:card, :user => @user, :day => @time.day,
                                :month => @time.month, :year => @time.year,)
      @user.has_done_todays_card?.should be_true
    end

    it 'should return false when user hasnt done a card today' do
      @user = FactoryGirl.create(:user, :admin => true)
      @time = Time.now - 1.day
      FactoryGirl.create(:card, :user => @user, :day => @time.day,
                                :month => @time.month, :year => @time.year,)
      @user.has_done_todays_card?.should be_false
    end
  end

  describe :has_done_yesterdays_card? do
    it 'should return true if user has done yesterdays card' do
      @user = FactoryGirl.create(:user, :admin => true)
      @time = Time.now - 1.day
      FactoryGirl.create(:card, :user => @user, :day => @time.day,
                                :month => @time.month, :year => @time.year,)
      @user.has_done_yesterdays_card?.should be_true
    end

    it 'should return false when user hasnt done a card today' do
      @user = FactoryGirl.create(:user, :admin => true)
      @time = Time.now
      FactoryGirl.create(:card, :user => @user, :day => @time.day,
                                :month => @time.month, :year => @time.year,)
      @user.has_done_yesterdays_card?.should be_false
    end
  end
end
