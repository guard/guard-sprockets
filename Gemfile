source 'https://rubygems.org'

gemspec

gem 'rake'
gem 'uglifier'

group :development do
  gem 'ruby_gntp'
  gem 'guard-rspec'
end

# The test group will be
# installed on Travis CI
#
group :test do
  gem 'json' if RUBY_VERSION =~ /^1\.8/
  gem 'rspec'
  gem 'coveralls', require: false
end
