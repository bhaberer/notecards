FactoryGirl.define do
  factory :card do
    entry 'Default Entry Text'
    user { |card| card.association(:user) }
  end

  factory :user do
    email 'tester@umloud.org'
    username 'tester'
    password 'foobar'
  end
end
