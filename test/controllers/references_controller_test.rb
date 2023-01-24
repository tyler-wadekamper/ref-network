require "test_helper"

class ReferencesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def submit_search(search_string)
    post search_references_url, params: { reference_search: search_string }, as: :turbo_stream
  end

  setup do
    build_sample_references('6')
  end

  test "search given a rule returns the correct references" do
    submit_search('6')

    assert_response :success

    assert_select 'ul.list-group' do
      assert_select 'a', 40
    end
  end

  test "search given a rule and section returns the correct references" do
    submit_search('6-2')

    assert_response :success

    assert_select 'ul.list-group' do
      assert_select 'a', 14
    end
  end

  test "search given a rule, section, article returns the correct references" do
    submit_search('6-3-2')

    assert_response :success

    assert_select 'ul.list-group' do
      assert_select 'a', 5
    end
  end

  test "search given a rule, section, article, subarticle returns the correct references" do
    submit_search('6-2-2.b')

    assert_response :success

    assert_select 'ul.list-group' do
      assert_select 'a', 2
    end
  end

  test "search given a rule name returns the correct references" do
    reference_name = Reference.all.order('created_at').second.name

    submit_search(reference_name)

    assert_response :success

    assert_select 'ul.list-group' do
      assert_select 'a', 5
    end
  end

  test "show action displays all recursive child questions" do
    parent = Reference.where("text = ?", '6')[0]
    child = Reference.where("text = ?", '6-1-2')[0]
    grandchild = Reference.where("text = ?", '6-1-2.c')[0]

    parent.questions = random_questions(5)
    child.questions = random_questions(5)
    grandchild.questions = random_questions(5)
    
    get reference_url(parent)
    assert_response :success
    assert_select 'div.question-card', 15

    get reference_url(child)
    assert_response :success
    assert_select 'div.question-card', 10

    get reference_url(grandchild)
    assert_response :success
    assert_select 'div.question-card', 5
  end
end
