# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    entry { 'Default Entry Text' }
    day { 1 }
    month { 1 }
    year { 2000 }
    user_id { 1 }

    factory :card_with_shift do
      rotation { 'cape' }
      time_in  { 'Jan 1 5pm' }
      time_out { 'Jan 1 6pm' }
      notes_duration { 0 }
    end
  end
end
