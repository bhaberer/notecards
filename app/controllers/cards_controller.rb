class CardsController < ApplicationController

  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cards }
    end
  end

  def month
    @cards = Card.where(:month => params[:month], :user_id => User.find_by_username(params[:username]))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cards }
    end
  end

  def day
    @cards = Card.where(:month => params[:month], :day => params[:day], :user_id => User.find_by_username(params[:username]))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cards }
    end
  end

  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @card }
    end
  end

  def new
    @card = Card.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @card }
    end
  end

  def edit
    @card = Card.find(params[:id])
  end

  def create
    @card = Card.new(:entry => params[:card][:entry],
                     :day => Time.zone.now.day,
                     :month => Time.zone.now.month,
                     :year => Time.zone.now.year,
                     :user => current_user)

    respond_to do |format|
      if @card.save
        format.html { redirect_to profile_path(current_user), :notice => 'Card was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to @card, :notice => 'Card was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :ok }
    end
  end
end
