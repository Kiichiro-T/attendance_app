require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  def setup
    @group = groups(:group1)
  end
  
  test "should be valid" do
    assert @group.valid?
  end
  
  test "name should be present" do
    @group.name = "      "
    assert_not @group.valid?
  end
  
  test "explanation should be present" do
    @group.explanation = "      "
    assert_not @group.valid?
  end
  
  test "name should not be too long" do
    @group.name = "a" * 51
    assert_not @group.valid?
  end
  
  test "explanation should not be too long" do
    @group.explanation = "a" * 1025 
    assert_not @group.valid?
  end
  
   test "user id should be present" do
    @group.user_id = nil
    assert_not @group.valid?
  end
end
