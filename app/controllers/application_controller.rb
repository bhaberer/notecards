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

end
