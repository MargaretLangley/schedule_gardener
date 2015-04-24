RSpec::Matchers.define :have_flash_error do |expected|
  match do |actual|
    expect(actual).to have_selector('.alert.alert-danger', text: expected)
  end

  failure_message do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end

RSpec::Matchers.define :have_flash_notice do |expected|
  match do |actual|
    expect(actual).to have_selector('.alert.alert-success', text: expected)
  end

  failure_message do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end

RSpec::Matchers.define :have_flash_success do |expected|
  match do |actual|
    expect(actual).to have_selector('.alert.alert-success', text: expected)
  end

  failure_message do |actual|
    "expected that #{actual} would have the banner #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have the banner #{expected}"
  end
end
