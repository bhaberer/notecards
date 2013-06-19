class Card < ActiveRecord::Base
  belongs_to :user
  attr_accessible :entry, :notes_duration, :rotation,
                  :time_in, :time_out, :user_id,
                  :day, :month, :year

  SHIFTS = {
    :anatom_path      => 'Anatomic Pathology',
    :behavior         => 'Behavior',
    :cape             => 'CAPE',
    :clin_path        => 'Clinical Pathology',
    :cardiology       => 'Cardiology',
    :dermatology      => 'Dermatology',
    :dentistry        => 'Dentistry',
    :fish_health      => 'Fish Health',
    :neurology        => 'Neuroogy',
    :nutrition        => 'Nutrition',
    :ophthalmology    => 'Ophthalmology',
    :oncology         => 'Oncology',
    :rad_onc          => 'Radiation Oncology',
    :shelter_med      => 'Shelter Medicine',
    :sa_anesthesia    => 'Small Animal Anesthesia (Critical Patient Care)',
    :sa_com_medicine  => 'Small Animal Community Medicine',
    :sa_emergency     => 'Small Animal Emergency',
    :sa_intensive     => 'Small Animal Intensive Care',
    :sa_medicine      => 'Small Animal Medicine',
    :sa_outpatient    => 'Small Animal Outpatient',
    :sa_radiology     => 'Small Animal Radiology',
    :sa_surgery       => 'Small Animal Surgery',
    :sa_surgery_soft  => 'Small Animal Surgery - Soft Tissue',
    :sa_surgery_ortho => 'Small Animal Surgery - Orthopedic'
  }

  validates :notes_duration, :presence => { :message => 'You need to fill this out (It can be 0)' },
                             :if => "rotation.present?"

  validates :rotation, :inclusion => { :in => SHIFTS.keys.map(&:to_s),
                                       :message => 'You need to select a rotation.' },
                       :allow_nil => true

  validates :user_id, :uniqueness => { :scope => [:day, :month, :year],
                                       :message => 'already has an entry for that day' }

  validates :day, :presence => true, :inclusion => { :in => 1..31 }

  validates :month, :presence => true, :inclusion => { :in => 1..12 }

  validates :year, :presence => true, :format => { :with => /^\d{4}$/ }

  validates :user, :presence => true

  validates :entry, :presence => { :message => 'You need to fill out the entry for today' },
                    :length => { :maximum => 365, :message => 'Maximum length is 365 characters' }

  [:time_out, :time_in].each do |method|
    validates method, :presence => { :message => 'Needs to be a valid time (i.e. Jan 15 5pm)' },
                      :if => "rotation.present?"
    define_method method.to_s do
      unless read_attribute(method).nil?
        read_attribute(method).strftime("%b %e %l:%M %P")
      end
    end

    define_method "#{method}=" do |time_str|
      begin
        if time_str.nil?
          write_attribute(method, nil)
        else
          write_attribute(method, Time.parse(time_str))
        end
      rescue ArgumentError
        write_attribute(method, nil)
      end
    end
  end

  def notes_duration
    return nil  if read_attribute(:notes_duration).nil?
    return 0    if read_attribute(:notes_duration).zero?

    time = []
    mins = read_attribute(:notes_duration) % 60
    time << "#{mins}m" unless mins.zero?

    hours = (read_attribute(:notes_duration) / 60).floor
    time << "#{hours}h" unless hours.zero?
    return time.join(' ')
  end

  def notes_duration=(time_str)
    if [0, '0'].include?(time_str)
      write_attribute(:notes_duration, 0)
    elsif time_str.nil?
      write_attribute(:notes_duration, nil)
    else
      hours = time_str[/(\d{1,2})\s?h/, 1].to_i
      mins  = time_str[/(\d{1,2})\s?m/, 1].to_i
      unless hours.zero? && mins.zero?
        write_attribute(:notes_duration, (hours * 60) + mins)
      end
    end
  end
end
