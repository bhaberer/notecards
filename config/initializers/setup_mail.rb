# frozen_string_literal: true

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  enable_starttls_auto: true,
  address: 'smtp.gmail.com',
  port: 587,
  authentication: :plain,
  user_name: '365notecards',
  password: ENV['MAIL_PASS']

}
