desc 'switch rails logger log level to debug'
task debug: [:environment, :verbose] do
  Rails.logger.level = Logger::DEBUG
end
