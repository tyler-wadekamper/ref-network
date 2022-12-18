ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

include FactoryBot::Syntax::Methods

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  EMPTY_VALUES = [nil, "", " "]
end

def build_user
  build(:default_user)
end

def create_user
  create(:default_user)
end