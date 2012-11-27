class DateAndTime
  attr_accessor :datetime
  def persisted?; false; end

  def initialize(args)
    @datetime =  args.fetch(:datetime, nil)
    if @datetime.nil?
      @datetime = date_and_time_to_datetime(args)
    end
  end

  def date
    @datetime.to_date
  end

  def time
    @datetime.strftime'%H:%M'
  end

  def date_and_time_to_datetime(args)
    date_time = "#{args.fetch(:date)} #{args.fetch(:time)}:00"
    DateTime.strptime(date_time,'%d %b %Y %H:%M')
  end

end