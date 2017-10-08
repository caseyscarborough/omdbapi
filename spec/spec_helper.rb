require 'omdbapi'
require 'vcr'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.filter_sensitive_data('<OMDB_API_KEY>') { OMDB.api_key }
end
