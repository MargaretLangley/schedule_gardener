#
# DateTimeWrapper
#
class DateTimeWrapper
  attr_reader :datetime
  def persisted?
    false
  end

  def initialize(args)
    @datetime =  args.fetch(:datetime, nil)
    @datetime = to_datetime(args) if datetime.nil?
  end

  def date
    datetime.to_date
  end

  def time
    datetime.strftime '%H:%M'
  end

  private

  #
  # Bug
  # DateTime.strptime(date_time, '%d %b %Y %H:%M').in_time_zone
  # Requires you to to explicitly include time zone which don't always have.
  # Safe to use Time.zone.parse
  #
  # Example Parse "1 Sep 2012 08:00:00"
  #
  # DateTime.strptime => Sat, 01 Sep 2012 09:00:00 BST +01:00
  # Time.zone.parse   => Sat, 01 Sep 2012 08:00:00 BST +01:00
  #
  def to_datetime(args)
    date_time = "#{args.fetch(:date)} #{args.fetch(:time)}:00"
    Time.zone.parse(date_time)
  end
end
