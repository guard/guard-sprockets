ENV['GUARD_ENV'] = 'test'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'guard/sprockets'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
