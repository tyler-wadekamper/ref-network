ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module UserBuilders
  def build_default_user
    build(:default_user)
  end

  def create_default_user
    create(:default_user)
  end

  def build_random_user
    build(:random_user)
  end

  def create_random_user
    create(:random_user)
  end
end

module ParamsDefinitions
  VALID_QUESTION_PARAMS = { question: { body: "new question",
                                        answer_attributes: { team: "A", 
                                                             down: "1", 
                                                             distance: "10", 
                                                             yardline_team: "A", 
                                                             yardline_num: "25", 
                                                             clock_status: "Ready", 
                                                             explanation: "" } } }.freeze

  INVALID_QUESTION_PARAMS = { question: { body: "",
                                          answer_attributes: { team: "A", 
                                                               down: "1", 
                                                               distance: "10", 
                                                               yardline_team: "A", 
                                                               yardline_num: "25", 
                                                               clock_status: "Ready", 
                                                               explanation: "" } } }.freeze

  VALID_UPDATE_PARAMS = { question: { body: "updated question",
                                      answer_attributes: { team: "A", 
                                                           down: "1", 
                                                           distance: "10", 
                                                           yardline_team: "A", 
                                                           yardline_num: "25", 
                                                           clock_status: "Ready", 
                                                           explanation: "" } } }.freeze
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  EMPTY_VALUES = [nil, "", " "]

  include FactoryBot::Syntax::Methods
  include UserBuilders
  include ParamsDefinitions
end
