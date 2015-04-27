# spec/support/factory_girl.rb
RSpec.configure do |config|
  # additional factory_girl configuration

  config.before(:suite) do
    begin
      Timecop.freeze(Time.zone.parse('1/1/2012 8:00'))
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
      Timecop.return
    end
  end
end
