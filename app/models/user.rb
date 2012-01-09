class User < ActiveRecord::Base

  has_many :cards

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :email_reminder

  validates_presence_of :username

  def gravatar(size=48) 
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase)}.png?s=#{size}&d=identicon"
  end

  def to_param
    username
  end

  def has_done_todays_card? 
    Card.where(:user_id => self, :day => Time.zone.now.day, :month => Time.zone.now.month, :year => Time.zone.now.year).present?
  end

end
