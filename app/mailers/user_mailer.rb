# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def reminder(user)
    @username = user.username

    mail(subject: '[ 365Cards ] Just a quick reminder...',
         to: user.email)
  end

  def new_user(user)
    @email = user.email
    @username = user.username

    mail(subject: '[ 365Cards ] New User!',
         to: User.admins.map(&:email).join(','))
  end
end
