class CardsController < ApplicationController
  respond_to :js
  before_filter :authenticate_user!, :except => [:index, :mailin]
  before_filter :auth_check 

  def mailin 
  end

  def month
    @user = User.find_by_username(params[:username])
    @cards = @user.cards_for_month(params[:month]) 
  end

  def day
    @day = params[:day]
    @month = params[:month]
    @user = User.find_by_username(params[:username])
    @cards = @user.cards_for_day(params[:month], params[:day]) 
  end
  
  def index
    @user = User.find_by_username!(params[:username])
    @cards = @user.last_entries
  end

  def new
    @day = today
    @month = today_month

    @card = Card.new
    @cards = current_user.cards_for_day(@month, @day)
  end

  def forgot
    @day = yesterday
    @month = yesterday_month

    @card = Card.new
    @cards = current_user.cards_for_day(@month, @day) 

    if current_user.has_done_yesterdays_card? 
      redirect_to home_path, :notice => 'You already filled out yesterdays card!'
    end
  end

  def create
    @card = Card.new(:entry => params[:card][:entry], :user => current_user)

    if params[:yesterday].present?
      @card.day   = yesterday
      @card.month = yesterday_month
      @card.year  = yesterday_year
    else 
      @card.day   = today
      @card.month = today_month
      @card.year  = today_year
    end 

    if @card.save
      @cards = current_user.cards_for_day(@month, @day) 
      redirect_to root_path, :notice => 'Thanks for updating, come back tomorrow.' 
    else
      @cards = current_user.cards_for_day(@month, @day) 
      @day = @card.day
      @month = @card.month
      render :action => "new"
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
