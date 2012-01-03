class StaticController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]

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
    @card = Card.new

    respond_to do |format|
      format.html
    end   
  end

end
