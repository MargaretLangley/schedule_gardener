require 'csv'

namespace :import do
  task touches: :environment do |_task, _args|
    Rails.logger.error "Missing touches: #{touches_file}" unless touches_file

    CSV.foreach(touches_file, headers: true) do |row|
      next if row.empty?
      Touch.new(row.to_hash).save(validate: false)
    end
  end

  def touches_file
    'import_data/touches.csv'
  end
end
