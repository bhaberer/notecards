class Card < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:day, :month, :year], :message => 'already has an entry for that day'
  validates_inclusion_of :day, :in => 1..31
  validates_inclusion_of :month, :in => 1..12
  validates_format_of :year, :with => /^\d{4}$/
  validates_presence_of :entry
  validates_presence_of :user
  validates_length_of :entry, :maximum => 365

  def self.card_for_date(time) 
    where(:day => time.day, :month => time.month, :year => time.year)
  end


end
