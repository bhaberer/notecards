class ApplicationController < ActionController::Base
  before_filter :set_user_time_zone

  protect_from_forgery

  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from ActionController::UnknownAction, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  private 
  
  def render_404
    respond_to do |format| 
      format.html { render :template => "static/notfound", :layout => 'application', :status => 404 }  
      format.all  { render :nothing => true, :status => 404 } 
    end
  end

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in? && current_user.time_zone.present?
  end

  def today 
    Time.zone.now.day
  end
  
  def today_month
    Time.zone.now.month
  end

  def today_year
    Time.zone.now.year
  end

  def yesterday 
    Time.zone.now.yesterday.day
  end
  
  def yesterday_month
    Time.zone.now.yesterday.month
  end

  def yesterday_year
    Time.zone.now.yesterday.year
  end
end
