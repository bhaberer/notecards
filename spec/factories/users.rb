# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'tester@weirdo513.org'
    username 'tester'
    password 'foobar'
  end
end
