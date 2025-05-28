# frozen_string_literal: true

module ApplicationHelper
  def resource_name
    :user
  end

  def entry_count(username, month, day)
    user = User.find_by(username: username)
    user.cards.where(month: month, day: day).count
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def months_hash
    months = {}
    Date::MONTHNAMES[1..12].each_with_index do |month_name, i|
      months[month_name.downcase.to_sym] = {
        days: Time.days_in_month(i),
        number: i,
        month_name: month_name
      }
    end
    months
  end
end
