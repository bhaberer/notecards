# frozen_string_literal: true

namespace :cards do
  desc 'Mail users who have not created an entry for the day.'
  task send_reminders: :environment do
    User.where(email_reminder: true).each do |user|
      UserMailer.reminder(user).deliver unless user.has_done_todays_card?
    end
  end
end
