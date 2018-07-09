require "bundler/setup"
require "rails/all"
require "setsy"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestApplication < Rails::Application
end

module Rails
  def self.root
    Pathname.new(File.expand_path("../", __FILE__))
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.env
    "test"
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name
    t.string :settings_data, :default => '{}'
    t.datetime :created_at
    t.datetime :updated_at
  end
end

RSpec.configure do |config|
  config.before(:all) do
    class User < ActiveRecord::Base
      serialize :settings_data, JSON
      include ::Setsy::DSL
      SETSY_DEFAULTS = {
          posts_limit: 10,
          marketing_emails: false
      }
      setsy :settings do |conf|
        conf.reader :posts_and_marketing do
          "User has #{posts_limit} post limit and marketing emails are #{marketing_emails}"
        end
      end
    end
  end

end

Rails.application.instance_variable_set("@initialized", true)