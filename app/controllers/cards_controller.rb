# frozen_string_literal: true

class CardsController < ApplicationController
  respond_to :js, :xls
  before_action :authenticate_user!, except: %i[index mailin]
  before_action :auth_check

  def data
    @cards = current_user.cards.order('year').order('month').order('day')
  end

  def mailin; end

  def month
    @user = User.find_by(username: params[:username])
    @cards = @user.cards_for_month(params[:month])
  end

  def day
    @day = params[:day]
    @month = params[:month]
    @user = User.find_by(username: params[:username])
    @cards = @user.cards_for_day(params[:month], params[:day])
  end

  def index
    @user = User.find_by!(username: params[:username])
    @cards = @user.last_entries

    @months = Date::MONTHNAMES[1..12]
    @month_days = {}
    (1..12).each do |m|
      @month_days[m - 1] = Time.days_in_month(m)
    end
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

    return unless current_user.has_done_yesterdays_card?

    redirect_to home_path, notice: 'You already filled out yesterdays card!'
  end

  def create
    @card = Card.new(params[:card])
    @card.user = current_user

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
      current_user.cards << @card
      @cards = current_user.cards_for_day(@month, @day)
      redirect_to root_path, notice: 'Thanks for updating, come back tomorrow.'
    else
      @cards = current_user.cards_for_day(@month, @day)
      @day = @card.day
      @month = @card.month
      if params[:yesterday].present?
        render action: :forgot
      else
        render action: :new
      end
    end
  end

  private

  def auth_check
    user = User.find_by(username: params[:username])

    return if user.blank?
    return if user == current_user || user.public? || (current_user.present? && current_user.admin?)

    redirect_to(root_path, notice: "Sorry, that user's cards are private")
  end

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

  def gallery_params
    params.require(:gallery).permit(:private, :title, :category_id, :description)
  end
end
