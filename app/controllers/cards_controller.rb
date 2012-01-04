class CardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :auth_check 

  def index
    @user = User.find_by_username!(params[:username])
    @cards = Card.where(:user => User.find_by_username(params[:username]))
    
    respond_to do |format|
      format.html 
    end
  end

  def month
    @cards = Card.where(:month => params[:month], 
                        :user_id => User.find_by_username(params[:username]))

    respond_to do |format|
      format.html
    end
  end

  def day
    @cards = Card.where(:month => params[:month], 
                        :day => params[:day], 
                        :user_id => User.find_by_username(params[:username]))

    respond_to do |format|
      format.html 
    end
  end


  def create
    @card = Card.new(:entry => params[:card][:entry],
                     :day => Time.zone.now.day,
                     :month => Time.zone.now.month,
                     :year => Time.zone.now.year,
                     :user => current_user)

    respond_to do |format|
      if @card.save
        format.html { redirect_to root_path, :notice => 'Your card was written on successfully' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  private 

  def auth_check 
    user = User.find_by_username(params[:username])
    
    if user.present?  
      unless user == current_user || user.public?
        redirect_to(root_path, :notice => "Sorry, that user's cards are private")
      end    
    end
  end

end
