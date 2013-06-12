class Card < ActiveRecord::Base
  belongs_to :user
  attr_accessible :entry, :notes_duration, :rotation,
                  :time_in, :time_out, :user_id

  SHIFTS = {
    :sa_anesthesia    => 'Small Animal Anesthesia (Critical Patient Care)',
    :sa_emergency     => 'Small Animal Emergency',
    :sa_intensive     => 'Small Animal Intensive Care',
    :sa_medicine      => 'Small Animal Medicine',
    :sa_com_medicine  => 'Small Animal Community Medicine',
    :sa_radiology     => 'Small Animal Radiology',
    :sa_surgery       => 'Small Animal Surgery',
    :sa_surgery_soft  => 'Small Animal Surgery - Soft Tissue',
    :sa_surgery_ortho => 'Small Animal Surgery - Orthopedic',

    :anatom_path      => 'Anatomic Pathology',
    :clin_path        => 'Clinical Pathology',
    :cardiology       => 'Cardiology',
    :dermatology      => 'Dermatology',
    :dentistry        => 'Dentistry',
    :neurology        => 'Neuroogy',
    :ophthalmology    => 'Ophthalmology',
    :oncology         => 'Oncology'
  }

  validates :time_in, :presence => true,
                      :allow_nil => true

  validates :time_out, :presence => true,
                       :allow_nil => true

  validates :notes_duration, :presence => true,
                             :allow_nil => true

  validates :rotation, :inclusion => { :in => SHIFTS.keys.map(&:to_s) },
                       :allow_nil => true

  validates :user_id, :uniqueness => { :scope => [:day, :month, :year],
                                       :message => 'already has an entry for that day' }

  validates :day, :presence => true,
                  :inclusion => { :in => 1..31 }

  validates :month, :presence => true,
                    :inclusion => { :in => 1..12 }

  validates :year, :presence => true,
                   :format => { :with => /^\d{4}$/ }

  validates :user, :presence => true

  validates :entry, :presence => true,
                    :length => { :maximum => 365 }

  validate :times_are_parsed

  def self.card_for_date(time)
    where(:day => time.day, :month => time.month, :year => time.year)
  end

  [:time_out, :time_in].each do |method|
    define_method method.to_s do
      unless read_attribute(method).nil?
        read_attribute(method).strftime("%b %e %l:%M %P")
      end
    end

    define_method "#{method}=" do |time_str|
      begin
        write_attribute(method, Time.parse(time_str))
      rescue ArgumentError
        errors.add(method, 'could not be parsed')
      end
    end
  end

  def notes_duration
    unless read_attribute(:notes_duration).nil?
      time = []
      mins = read_attribute(:notes_duration) % 60
      time << "#{mins} mins" unless mins.zero? 

      hours = (read_attribute(:notes_duration) / 60).floor
      time << "#{hours} hours" unless hours.zero?
      return time.join(' ')
    end
  end

  def notes_duration=(time_str)
    hours = time_str[/(\d{1,2})\s?h/, 1].to_i || 0
    mins  = time_str[/(\d{1,2})\s?m/, 1].to_i || 0
    if hours.zero? && mins.zero?
      errors.add(method, 'could not be parsed')
      false
    else
      write_attribute(:notes_duration, (hours * 60) + mins)
    end
  rescue
    errors.add(:notes_duration, 'could not be parsed')
    false
  end

  private

  def times_are_parsed
    return true unless self.user.vet?
    [:time_out, :time_in].each do |time|
      return if read_attribute(time).nil?
      unless Time.parse(read_attribute(time).to_s)
        errors.add(method, "was not a valid time")
      end
    end
  end
end
