module TrackingNumberService
  def self.generate_tracking_number
    configs = YAML.load_file "#{Rails.root}/config/application.yml"
    site_code = configs['facility_code']
    current_date = Time.now.strftime('%Y%m%d')
    year = current_date[2..3]
    month = get_month(Time.now.strftime('%m'))
    day = get_day(Time.now.strftime('%d'))
    
  # Use a database transaction to ensure atomic updates
    tracking_number = nil
    TrackerJson.transaction do
      tracker = TrackerJson.find_or_create_by(id: 1)
      tracker = tracker.update(tracker: {"#{current_date}": 0}) if (tracker.tracker.blank? || tracker.tracker[current_date].blank?)
      counter = tracker.tracker[current_date].to_i + 1
      tracker.update(tracker: {"#{current_date}": counter})
      value = format('%03d', counter)
      tracking_number = "X#{site_code}#{year}#{month}#{day}#{value}"
    end

    tracking_number
  end

  def self.get_month(month)
    ('1'..'9').to_a + ('A'..'C').to_a[0..2][month.to_i - 1]
  end

  def self.get_day(day)
    (('1'..'9').to_a + ('A'..'C').to_a + ('E'..'H').to_a + %w[Y J K Z M N O P Q R S T V W X])[day.to_i - 1]
  end
end
