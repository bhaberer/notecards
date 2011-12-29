module ApplicationHelper
  
  def entry_today?(user = current_user)
    Card.where(:user_id => user, :day => Time.now.day, :month => Time.now.month, :year => Time.now.year).present?
  end


end
