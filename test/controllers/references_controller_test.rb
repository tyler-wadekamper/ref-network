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
  
  class ReferencesWithQuestionsTest < ReferencesControllerTest
    setup do
      @parent = Reference.where("text = '6'").first
      @child = Reference.where("text = '6-1-2'").first
      @grandchild = Reference.where("text = '6-1-2.c'").first
  
      @parent.questions = random_questions(3)
      @child.questions = random_questions(3)
      @grandchild.questions = random_questions(3)
    end

    test "search given a rule returns the correct number of child questions" do
      submit_search('6')
      assert_response :success

      assert_select "a#reference_link_#{@parent.id}" do
        assert_select 'span.badge', '9'
      end
    end

    test "search given an article returns the correct number of child questions" do
      submit_search('6-1-2')
      assert_response :success

      assert_select "a#reference_link_#{@child.id}" do
        assert_select 'span.badge', '6'
      end
    end

    test "search given a subarticle returns the correct number of child questions" do
      submit_search('6-1-2.c')
      assert_response :success

      assert_select "a#reference_link_#{@grandchild.id}" do
        assert_select 'span.badge', '3'
      end
    end
  
    test "show for a rule displays all recursive child questions" do
      get reference_url(@parent)
      assert_response :success
      assert_select 'div.question-card', 9
    end

    test "show for an article displays all recursive child questions" do
      get reference_url(@child)
      assert_response :success
      assert_select 'div.question-card', 6
    end

    test "show for a subarticle displays all recursive child questions" do
      get reference_url(@grandchild)
      assert_response :success
      assert_select 'div.question-card', 3
    end
  end
end
