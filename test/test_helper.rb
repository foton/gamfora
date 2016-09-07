# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new




#Create  APP (not Engine) fixtures
::User.delete_all
::User.create!(name: "John Doe", username: "game_owner")
::User.create!(name: "Conan O'Brian", username: "user1")
::User.create!(name: "John Carmack",  username: "user2")
::User.create!(name: "Bugsy", username: "user3")

def users(username)
  unless defined?(@users)
    @users={}
    User.all.each do |u|
      @users[u.username.to_sym]=u
    end  
  end 
  @users[username.to_sym]
end  

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

require "pry"

