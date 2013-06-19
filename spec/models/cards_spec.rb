require 'spec_helper'

describe Card do

  before(:each) do
    Card.all.map(&:destroy)
  end

  describe 'attribute validations' do
    describe :entry do
      it "should require an entry" do
        FactoryGirl.build(:card, :entry => nil).should_not be_valid
        FactoryGirl.build(:card, :entry => String.new).should_not be_valid
        FactoryGirl.build(:card, :entry => "Testing").should be_valid
      end

      it "should require an entry shorter than 365 chars" do
        FactoryGirl.build(:card, :entry => ('.' * 366)).should_not be_valid
        FactoryGirl.build(:card, :entry => ('.' * 365)).should be_valid
        FactoryGirl.build(:card, :entry => '.').should be_valid
      end
    end

    describe :day do
      it "should require a day" do
        FactoryGirl.build(:card, :day => nil).should_not be_valid
        FactoryGirl.build(:card, :day => String.new).should_not be_valid
        FactoryGirl.build(:card, :day => 3).should be_valid
      end

      it "should require a day between 1-31" do
        FactoryGirl.build(:card, :day => 0).should_not be_valid
        (1..31).each { |n| FactoryGirl.build(:card, :day => n).should be_valid }
        FactoryGirl.build(:card, :day => 32).should_not be_valid
      end
    end

    describe :month do
      it "should require a month" do
        FactoryGirl.build(:card, :month => nil).should_not be_valid
        FactoryGirl.build(:card, :month => String.new).should_not be_valid
        FactoryGirl.build(:card, :month => 1).should be_valid
      end

      it "should require a month between 1-12" do
        FactoryGirl.build(:card, :month => 0).should_not be_valid
        (1..12).each { |n| FactoryGirl.build(:card, :month => n).should be_valid }
        FactoryGirl.build(:card, :month => 13).should_not be_valid
      end
    end

    describe :year do
      it "should require a year" do
        FactoryGirl.build(:card, :year => nil).should_not be_valid
        FactoryGirl.build(:card, :year => 2000).should be_valid
      end

      it "should require a year in the right format" do
        [2, 20, 200, 20000, 'abc', Hash.new].each do |n|
          FactoryGirl.build(:card, :year => n).should_not be_valid
        end
        FactoryGirl.build(:card, :year => 2000).should be_valid
      end
    end

    describe :user do
      it "should require a user" do
        FactoryGirl.build(:card, :user_id => nil).should_not be_valid
        FactoryGirl.build(:card, :user_id => 0).should_not be_valid
        FactoryGirl.build(:card, :user_id => 1).should be_valid
      end
    end

    describe :rotation do
      it "should not allow blank rotations" do
        FactoryGirl.build(:card_with_shift, :rotation => '').should_not be_valid
      end

      it "should allow nil rotations" do
        FactoryGirl.build(:card_with_shift, :rotation => nil).should be_valid
      end

      it "should not allow rotations not in Card::SHIFTS" do
        FactoryGirl.build(:card_with_shift, :rotation => 'cooking').should_not be_valid
      end

      it "should allow any Card::SHIFTS entry" do
        Card::SHIFTS.keys.each do |shift|
          FactoryGirl.build(:card_with_shift, :rotation => shift.to_s).should be_valid
        end
      end
    end

    describe 'time_in & time_out' do
      [:time_in, :time_out].each do |field|
        it "#{field} should be allowed to be nil if :rotation is also nil" do
          card = FactoryGirl.build(:card_with_shift, :rotation => nil, field => nil)
          card.valid?
          card.errors.messages[field].should be_nil
        end

        it "#{field} should be allowed to be nil if :rotation is blank" do
          card = FactoryGirl.build(:card_with_shift, :rotation => '', field => nil)
          card.valid?
          card.errors.messages[field].should be_nil
        end

        it "#{field} should not be allowed to be nil if :rotation is valid" do
          card = FactoryGirl.build(:card_with_shift, :rotation => :cape, field => nil)
          card.valid?
          card.errors.messages[field].should_not be_nil
        end

        it "#{field} should not save if the string does not parse into a valid time" do
          FactoryGirl.build(:card_with_shift, field => 'boourns').should_not be_valid
        end

        it "#{field} should add an error to the object if the string does not parse" do
          card = FactoryGirl.build(:card_with_shift, field => 'boourns')
          card.valid?
          card.errors.messages[field].should include('Needs to be a valid time (i.e. Jan 15 5pm)')
        end

        it "#{field} should parse the user's string into a Time object" do
          FactoryGirl.build(:card_with_shift, field => 'Jun 9 2003 4pm').
            read_attribute(field).
            should == 'Mon, 09 Jun 2003 16:00:00 PDT -07:00'
        end
      end
    end

    describe :notes_duration do
      it 'should be allowed to be nil when the shift is nil' do
        card = FactoryGirl.build(:card_with_shift, :rotation => nil, :notes_duration => nil)
        card.valid?
        card.errors.messages[:notes_duration].should be_nil
      end

      it 'should be allowed to be nil when the shift is blank' do
        card = FactoryGirl.build(:card_with_shift, :rotation => '', :notes_duration => nil)
        card.valid?
        card.errors.messages[:notes_duration].should be_nil
      end

      it 'should not be allowed to be nil when the shift is valid' do
        card = FactoryGirl.build(:card_with_shift, :rotation => :cape, :notes_duration => nil)
        card.valid?
        card.errors.messages[:notes_duration].should_not be_nil
      end

      it 'should be allowed to be set to "0"' do
        card = FactoryGirl.build(:card_with_shift, :notes_duration => '0')
        card.should be_valid
        card.notes_duration.should == 0
      end

      it 'should not save if the string does not parse' do
        FactoryGirl.build(:card_with_shift, :notes_duration => 'hodor').
          should_not be_valid
      end

      it 'should save if the string does parse' do
        ['1hour', '3 hours', '12 h', '1h 2m', '1 hour 27m', '36 minutes', '23m'].each do |time|
          FactoryGirl.build(:card_with_shift, :notes_duration => time).
            should be_valid
        end
      end
    end
  end
end


