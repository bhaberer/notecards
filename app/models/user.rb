class User < ActiveRecord::Base

  has_many :cards

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
          :validatable, :reconfirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :email_reminder

  validates_presence_of :username

  def gravatar(size=48)
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase)}.png?s=#{size}&d=identicon"
  end

  def to_param
    username
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
    self.cards.card_for_date(Time.zone.now).first.present?
  end

  def has_done_yesterdays_card?
    self.cards.card_for_date(Time.zone.now - 1.day).first.present?
  end

end
