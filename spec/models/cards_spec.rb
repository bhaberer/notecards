# frozen_string_literal: true

require 'spec_helper'

describe Card do
  before(:all) do
    @user = FactoryGirl.build(:user)
  end

  before do
    described_class.all.map(&:destroy)
  end

  describe 'attribute validations' do
    describe :entry do
      it 'requires an entry' do
        FactoryGirl.build(:card, user: @user, entry: nil).should_not be_valid
        FactoryGirl.build(:card, user: @user, entry: String.new).should_not be_valid
        FactoryGirl.build(:card, user: @user, entry: 'Testing').should be_valid
      end

      it 'requires an entry shorter than 365 chars' do
        FactoryGirl.build(:card, user: @user, entry: ('.' * 366)).should_not be_valid
        FactoryGirl.build(:card, user: @user, entry: ('.' * 365)).should be_valid
        FactoryGirl.build(:card, user: @user, entry: '.').should be_valid
      end
    end

    describe :day do
      it 'requires a day' do
        FactoryGirl.build(:card, user: @user, day: nil).should_not be_valid
        FactoryGirl.build(:card, user: @user, day: String.new).should_not be_valid
        FactoryGirl.build(:card, user: @user, day: 3).should be_valid
      end

      it 'requires a day between 1-31' do
        FactoryGirl.build(:card, user: @user, day: 0).should_not be_valid
        (1..31).each { |n| FactoryGirl.build(:card, user: @user, day: n).should be_valid }
        FactoryGirl.build(:card, user: @user, day: 32).should_not be_valid
      end
    end

    describe :month do
      it 'requires a month' do
        FactoryGirl.build(:card, user: @user, month: nil).should_not be_valid
        FactoryGirl.build(:card, user: @user, month: String.new).should_not be_valid
        FactoryGirl.build(:card, user: @user, month: 1).should be_valid
      end

      it 'requires a month between 1-12' do
        FactoryGirl.build(:card, user: @user, month: 0).should_not be_valid
        (1..12).each { |n| FactoryGirl.build(:card, user: @user, month: n).should be_valid }
        FactoryGirl.build(:card, user: @user, month: 13).should_not be_valid
      end
    end

    describe :year do
      it 'requires a year' do
        FactoryGirl.build(:card, user: @user, year: nil).should_not be_valid
        FactoryGirl.build(:card, user: @user, year: 2000).should be_valid
      end

      it 'requires a year in the right format' do
        [2, 20, 200, 20_000, 'abc', {}].each do |n|
          FactoryGirl.build(:card, user: @user, year: n).should_not be_valid
        end
        FactoryGirl.build(:card, user: @user, year: 2000).should be_valid
      end
    end

    describe :user do
      it 'requires a user' do
        FactoryGirl.build(:card, user_id: nil).should_not be_valid
        FactoryGirl.build(:card, user_id: 0).should_not be_valid
        FactoryGirl.build(:card, user: @user).should be_valid
      end
    end

    describe :rotation do
      it 'does not allow blank rotations' do
        FactoryGirl.build(:card_with_shift, user: @user, rotation: '')
                   .should_not be_valid
      end

      it 'allows nil rotations' do
        FactoryGirl.build(:card_with_shift, user: @user, rotation: nil)
                   .should be_valid
      end

      it 'does not allow rotations not in Card::SHIFTS' do
        FactoryGirl.build(:card_with_shift, user: @user, rotation: 'cooking')
                   .should_not be_valid
      end

      it 'allows any Card::SHIFTS entry' do
        Card::SHIFTS.each_key do |shift|
          FactoryGirl.build(:card_with_shift, user: @user, rotation: shift.to_s)
                     .should be_valid
        end
      end
    end

    describe 'time_in & time_out' do
      it 'does not allow them to be equal' do
        FactoryGirl.build(:card_with_shift, rotation: :cape, time_in: '7pm', time_out: '7pm')
                   .should_not be_valid
      end

      %i[time_in time_out].each do |field|
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
          FactoryGirl.build(:card_with_shift, field => 'Jun 9 2003 4pm')
                     .read_attribute(field)
                     .should == 'Mon, 09 Jun 2003 16:00:00 PDT -07:00'
        end
      end
    end

    describe :notes_duration do
      it 'is allowed to be nil when the shift is nil' do
        card = FactoryGirl.build(:card_with_shift, rotation: nil, notes_duration: nil)
        card.valid?
        card.errors.messages[:notes_duration].should be_nil
      end

      it 'is allowed to be nil when the shift is blank' do
        card = FactoryGirl.build(:card_with_shift, rotation: '', notes_duration: nil)
        card.valid?
        card.errors.messages[:notes_duration].should be_nil
      end

      it 'is not allowed to be nil when the shift is valid' do
        card = FactoryGirl.build(:card_with_shift, rotation: :cape, notes_duration: nil)
        card.valid?
        card.errors.messages[:notes_duration].should_not be_nil
      end

      it 'is allowed to be set to "0"' do
        card = FactoryGirl.build(:card_with_shift, user: @user, notes_duration: '0')
        card.should be_valid
        card.notes_duration.should == 0
      end

      it 'does not save if the string does not parse' do
        FactoryGirl.build(:card_with_shift, user: @user, notes_duration: 'hodor')
                   .should_not be_valid
      end

      it 'saves if the string does parse' do
        ['1hour', '3 hours', '12 h', '1h 2m', '1 hour 27m', '36 minutes', '23m'].each do |time|
          FactoryGirl.build(:card_with_shift, user: @user, notes_duration: time)
                     .should be_valid
        end
      end
    end
  end
end
