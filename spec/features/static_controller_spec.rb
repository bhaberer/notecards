require 'spec_helper'

describe "Notecards Static views" do

  before(:each) do
    User.all.map(&:destroy)
    visit root_path
  end

  describe "as a guest on the home page" do

    describe 'the sign up flow' do
      it "should show the front page to guests" do
        page.should have_link('Sign Up')
      end

      it "should allow guests to navigate to the signup page" do
        within('.main') do
          click_link('Sign Up')
        end
        page.should have_xpath('//form[@class="form-horizontal"]')
      end

      it "should show guests the signup form on the signup page" do
        within('.main') do
          click_link('Sign Up')
        end

        page.should have_field('user_username')
        page.should have_field('user_email')
        page.should have_field('user_password')
        page.should have_field('user_password_confirmation')
      end
    end

    it "should allow guests to navigate to the signin page" do
      within('.navbar') do
        click_link('Log In')
      end
      page.should have_xpath('//form[@class="form-horizontal"]')
    end

    it "should allow guests to navigate to the signin page" do
      within('.navbar') do
        click_link('Log In')
      end

      page.should have_field('user_username')
      page.should have_field('user_password')
    end

    it "should not allow guests to access user profiles" do
      FactoryGirl.create(:user, :username => 'bob', :email => 'bob1@foobar.com')

      visit profile_path('bob')

      page.should have_content("Sorry, that user's cards are private")
    end

    it "should not allow guests to access user profiles for users that do not exist" do
      visit profile_path('brad')

      page.should have_content("404!")
    end
  end

  context "as a new user" do

    it "should show allow guests to signup on the signup page" do
      within('.main') do
        click_link('Sign Up')
      end

      page.fill_in 'Username', :with => 'tester'
      page.fill_in 'Email', :with => 'tester@fadedpixels.net'
      page.fill_in 'Password', :with => 'notecard'
      page.fill_in 'Confirm Password', :with => 'notecard'
      page.click_button 'Sign up'

      page.should have_content("Logged in as tester")

    end

    it "should allow users to log in" do
      reset_session!
      visit login_path
      FactoryGirl.create(:user, :username => 'tester', :password => 'notecard')

      page.fill_in 'Username', :with => 'tester'
      page.fill_in 'Password', :with => 'notecard'
      page.click_button 'Login'

      URI.parse(current_url).path.should == home_path
    end

  end

  context "as an existing user" do
    before(:each) do
      FactoryGirl.create(:user, :username => 'tester', :password => 'notecard')
      visit login_path
      page.fill_in 'Username', :with => 'tester'
      page.fill_in 'Password', :with => 'notecard'
      page.click_button 'Login'
    end

    it "should show the logged in user the card for the day" do
      page.should have_content([Time.now.month, Time.now.day, Time.now.year].join(' / '))
      page.should have_xpath("//textarea[@id='card_entry']")
    end

    it "should allow the user to fill out the card for the day" do
      page.fill_in 'card_entry', :with => 'Testing Entry'
      page.click_button "Save Card"
    end
  end
end
