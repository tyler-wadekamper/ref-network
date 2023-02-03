require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
  test "saves when all attributes are present" do
    reference = build(:default_reference)
    assert reference.save
  end

  test "saves with only a rule" do
    reference = build(:default_reference, section: nil, article: nil, subarticle: nil)
    assert reference.save
  end

  test "does not save when not provided with a rule" do
    reference = build(:default_reference, rule: nil)
    assert_not reference.save
  end

  test "does not save without attributes present" do
    reference = Reference.new
    assert_not reference.save
  end

  test "#parent returns parent reference" do
    child_references = create_list(:random_reference, 3)
    parent_reference = create(:random_reference)

    child_references.each do |child|
      parent_reference.children << child
    end

    child_references.each do |child|
      assert_equal child.parent, parent_reference
    end
  end

  test "#children returns list of child references" do
    child_references = create_list(:random_reference, 3)
    parent_reference = create(:random_reference)

    child_references.each do |child|
      parent_reference.children << child
    end

    assert_equal parent_reference.children, child_references
  end
end
