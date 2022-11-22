FactoryBot.define do
  factory :user do
    email { 'tester@example.org' }
    username { 'tester' }
    password { 'foobar' }
  end
end
