class Card < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:day, :month, :year], :message => 'already has an entry for that day'

end
