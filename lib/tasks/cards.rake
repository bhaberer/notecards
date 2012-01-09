namespace :cards do

  desc "Mail users who have not created an entry for the day."
  task :send_reminders => :environment do
    User.where(:email_reminder => true).each do |user|
      unless user.has_done_todays_card?
        UserMailer.reminder(user).deliver
      end
    end
  end

end
