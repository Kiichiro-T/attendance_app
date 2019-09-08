require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(user_id:  users(:user1).id,
                                    group_id: groups(:group1).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.user_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.group_id = nil
    assert_not @relationship.valid?
  end
end
