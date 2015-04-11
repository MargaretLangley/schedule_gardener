# config required if will paginate in the application (which it is with mine)

Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
