RSpec::Matchers.define :have_flash_error do |expected|
  match do |actual|
    actual.should have_selector('div.alert.alert-alert', text: expected)
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end

RSpec::Matchers.define :have_flash_notice do |expected|
  match do |actual|
    actual.should have_selector('div.alert.alert-notice', text: expected)
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end

RSpec::Matchers.define :have_flash_success do |expected|
  match do |actual|
    actual.should have_selector('div.alert.alert-success', text: expected)
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end
