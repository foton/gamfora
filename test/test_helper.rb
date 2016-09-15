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
::User.create!(name: "Salomon", username: "user4")

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

def assert_redirected_to_games_with_message(msg=nil)
  assert_redirected_to games_url
  assert_equal (msg||"Takovou hru nemáte ve vlastnickém portfoliu!"), flash[:alert]
end  

def assert_tr_with_actions(actions_allowed,resources_name,destroy_link_text)
  {show: "Detail", edit: "Editace", destroy: destroy_link_text}.each_pair do |action_id, link_text|
    if actions_allowed.include?(action_id)
      assert_select "td.#{action_id}" do 
        assert_select "a", link_text
      end  
    else
      assert_select "td.#{action_id}", false, "There should be no #{action_id} for #{resources_name}"
      assert_select "a",{text: link_text, count: 0}, "There should be no #{action_id} link for #{resources_name}"
    end  
  end  
end  
          

