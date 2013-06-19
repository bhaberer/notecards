class User < ActiveRecord::Base

  has_many :cards
  after_create :notify_admins

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
          :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username,
                  :email_reminder

  validates_presence_of :username

  def card_for_date(time)
    self.cards_for_date(time).first
  end

  def cards_for_date(time)
    self.cards.where(:day => time.day, :month => time.month, :year => time.year)
  end

  def gravatar(size=48)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase)}.png?s=#{size}&d=identicon"
  end

  def to_param
    username
  end

  def self.admins
    where(:admin => true)
  end

  def cards_for_month(month)
    self.cards.where(:month => month)
  end

  def cards_for_day(month, day)
    self.cards.where(:month => month, :day => day)
  end

  def last_entries
    self.cards.limit(10)
  end

  def has_done_todays_card?
    self.card_for_date(Time.zone.now).present?
  end

  def has_done_yesterdays_card?
    self.card_for_date(Time.zone.now - 1.day).present?
  end

  private

  def notify_admins
    UserMailer.new_user(self).deliver unless User.admins.blank?
  end
end
