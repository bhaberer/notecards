class StaticController < ApplicationController

  def index 
    if user_signed_in? 
      redirect_to home_path
    end 
  end 

  def notfound
  end

end
