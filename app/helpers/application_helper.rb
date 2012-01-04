module ApplicationHelper
  
  def entry_today?(user = current_user)
    Card.where(:user_id => user, :day => Time.zone.now.day, :month => Time.zone.now.month, :year => Time.zone.now.year).present?
  end


end
