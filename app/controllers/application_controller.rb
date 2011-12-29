class ApplicationController < ActionController::Base
  before_filter :set_user_time_zone

  protect_from_forgery

  private 

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in? && current_user.time_zone.present?
  end

end
