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
    @day = params[:day]
    @month = params[:month]
    @cards = Card.where(:month => params[:month], 
                        :day => params[:day], 
                        :user_id => User.find_by_username(params[:username]))

    respond_to do |format|
      format.html 
    end
  end

  def new
    @forgot = forgot_yesterday? 
    @day = today
    @month = today_month

    @card = Card.new
    @cards = Card.where(:month => @month, :day => @day, :user_id => current_user)

    respond_to do |format|
      format.html
    end
  end

  def forgot
    @day = yesterday
    @month = yesterday_month

    @card = Card.new
    @cards = Card.where(:month => @month, :day => @day, :user_id => current_user)

    respond_to do |format|
      if forgot_yesterday? 
        format.html
      else 
        format.html { redirect_to home_path, 
                      :notice => 'You already filled out yesterdays card!' }
      end
    end
  end

  def create
    if params[:yesterday].present?
      @card = Card.new(:entry => params[:card][:entry],
                       :day => yesterday,
                       :month => yesterday_month,
                       :year => yesterday_year,
                       :user => current_user)
    else 

      @card = Card.new(:entry => params[:card][:entry],
                       :day => today,
                       :month => today_month,
                       :year => today_year,
                       :user => current_user)
    end
    respond_to do |format|
      if @card.save
        @cards = Card.where(:month => @month, :day => @day, :user_id => current_user)
        format.html { redirect_to root_path, :notice => 'Thanks for updating, come back tomorrow.' }
        format.js { render :layout => false } 
      else
        @cards = Card.where(:month => @month, :day => @day, :user_id => current_user)
        if params[:yesterday].present?
          @day = yesterday
          @month = yesterday_month
        else 
          @day = today
          @month = today_month
        end

        format.html { render :action => "new" }
        format.js { render :layout => false } 
      end
    end
  end

  private 

  def forgot_yesterday?
    Card.where(:user_id => current_user,
               :day => yesterday,
               :month => yesterday_month,
               :year => yesterday_year).count == 0
  end

  def auth_check 
    user = User.find_by_username(params[:username])
    
    if user.present?  
      unless user == current_user || user.public?
        redirect_to(root_path, :notice => "Sorry, that user's cards are private")
      end    
    end
  end

end
