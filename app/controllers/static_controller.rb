class StaticController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :notfound]

  def index 
    respond_to do |format|
      if user_signed_in? 
        format.html { redirect_to home_path }
      else 
        format.html 
      end
    end
  end 

  def home 
    @day = Time.zone.now.day
    @month = Time.zone.now.month

    @card = Card.new
    @cards = Card.where(:month => @month, :day => @day, :user_id => current_user)

    respond_to do |format|
      format.html
    end   
  end

  def notfound
    respond_to do |format|
      format.html
    end
  end

end
