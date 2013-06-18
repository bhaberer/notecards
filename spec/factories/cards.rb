FactoryGirl.define do
  factory :card do
    entry 'Default Entry Text'
    user { |card| card.association(:user) }
  end
end
