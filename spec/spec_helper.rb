require 'rubygems'
require 'bundler/setup'

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/gemfiles/'
  enable_coverage :branch

  if ENV['CI']
    minimum_coverage line: 100, branch: 100
  end
end

require 'logger'
require 'rspec'
require 'active_record'
require 'mongoid'

require 'simple_enum'

require 'support/active_record_support'
require 'support/i18n_support'
require 'support/model_support'
require 'support/mongoid_support'

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.include ModelSupport
  config.include I18nSupport, i18n: true
  config.include ActiveRecordSupport, active_record: true
  config.include MongoidSupport, mongoid: true
end
