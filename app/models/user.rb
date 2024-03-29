# frozen_string_literal: true

class User < ApplicationRecord
  has_many :cards
  after_create :notify_admins

  devise  :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
          :validatable

  validates :username, presence: { message: 'You need to pick a username' }

  def gravatar(size = 48)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}.png?s=#{size}&d=identicon"
  end

  def to_param
    username
  end

  def self.admins
    where(admin: true)
  end

  def card_for_date(time)
    cards_for_day(time.month, time.day).where(year: time.year).first
  rescue NoMethodError
    []
  end

  def cards_for_day(month, day)
    cards_for_month(month).where(day:)
  end

  def cards_for_month(month)
    cards.where(month:)
  end

  def cards_for_year(year)
    cards.where(year:)
  end

  def last_entries
    cards.order('year desc, month desc, day desc').limit(10)
  end

  def has_done_todays_card?
    card_for_date(Time.zone.now).present?
  end

  def has_done_yesterdays_card?
    card_for_date(Time.zone.now - 1.day).present?
  end

  private

  def notify_admins
    UserMailer.new_user(self).deliver if User.admins.present?
  end
end
