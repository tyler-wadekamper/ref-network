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
end
