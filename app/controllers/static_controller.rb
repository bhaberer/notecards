class StaticController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]

  def index 
    @card = Card.new

    respond_to do |format|
      format.html
    end
  end 

  def home 
   
    respond_to do |format|
      format.html
    end   
  end

end
