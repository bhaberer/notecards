module ApplicationHelper
  
  def entry_today?(user = current_user)
    Card.where(:user_id => user, :day => Time.zone.now.day, :month => Time.zone.now.month, :year => Time.zone.now.year).present?
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
