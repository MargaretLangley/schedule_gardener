class DateAndTimeRange
  attr_accessor :end, :start

  def initialize(args)
    @start = DateAndTime.new(datetime: args.fetch(:start, nil),
                             date:     args.fetch(:start_date, nil),
                             time:     args.fetch(:start_time, nil))
    if args.fetch(:length, nil)
      @end = DateAndTime.new(datetime: @start.datetime + args.fetch(:length).to_i.minutes)
    else
      @end = DateAndTime.new(datetime: args.fetch(:end, nil),
                             date:     args.fetch(:end_date, nil),
                             time:     args.fetch(:end_time, nil)
                            )
    end
  end

  def start_date
    @start.date
  end

  def start_time
    @start.time
  end

  def length
    ((self.end.datetime - start.datetime) / 60).floor
  end

  def persisted?
    false
  end
end
