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

module QuestionBuilder
  def random_questions(quantity)
    user = create_random_user
    
    questions = []
    quantity.times do
      answer = build(:random_answer)
      questions << build(:random_question, author: user, answer:)
    end
    questions
  end

  def create_questions(number, author: nil, reference: nil)
    @user = create_default_user unless author
    reference_ids = Reference.all.sample(5).map(&:id) unless reference
    reference_ids = [reference.id] if reference
    number.times do
      answer = build(:random_answer)
      create(:random_question, author: @user, answer:, reference_ids:) unless author
      create(:random_question, author:, answer:, reference_ids:) if author
    end
  end
end

module ReferenceSamples
  def create_sample_references(rule_string)
    parent = create(:nil_reference_with_name, rule: rule_string)

    ('1'..'3').each do |section|
      rule_child = create(:nil_reference_with_name, rule: rule_string, section:)
      parent.children << rule_child

      ('1'..'3').each do |article|
        section_child = create(:nil_reference_with_name, rule: rule_string, section:, article:)
        rule_child.children << section_child

        ('a'..'c').each do |subarticle|
          article_child = create(:nil_reference, rule: rule_string, section:, article:, subarticle:)
          section_child.children << article_child
        end
      end
    end
  end
end

module PageNavigation
  def scroll_down
    page.execute_script "window.scrollBy(0,10000)"
  end
end

module QuestionContent
  def assert_questions(number)
    assert_selector "turbo-frame.question", count: number
  end

  def assert_scroll_functionality
    assert_questions(15)

    scroll_down
    assert_questions(30)

    scroll_down
    assert_questions(45)

    scroll_down
    assert_questions(50)
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
module ValidAnswerAttributes
  VALID_TEAMS = %w[A B]
  VALID_DOWNS = %w[1 2 3 4 FK]
  VALID_DISTANCE = ('1'..'99').to_a.append("G")
  VALID_YARDLINE_NUM = ('1'..'50').to_a
  VALID_CLOCK_STATUS = ['Ready', 'Snap', 'Running', 'On legal touch', 'Untimed']
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  EMPTY_VALUES = [nil, "", " "]

  include FactoryBot::Syntax::Methods
  include UserBuilders
  include ParamsDefinitions
  include ValidAnswerAttributes
  include ReferenceSamples
  include QuestionBuilder
  include PageNavigation
  include QuestionContent
end
