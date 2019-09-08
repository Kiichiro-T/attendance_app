require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:user1)
    @group = groups(:group1)
    @group2 = groups(:group2)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |group|
      assert_select "a[href=?]", group_path(group)
    end
  end

  test "followers page" do
    get followers_group_path(@group2)
    assert_not @group2.followers.empty?
    assert_match @group2.followers.count.to_s, response.body
    @group2.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "should follow a group the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { group_id: @group.id }
    end
  end

  test "should follow a group with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { group_id: @group.id }
    end
  end

  test "should unfollow a group the standard way" do
    @user.follow(@group)
    relationship = @user.active_relationships.find_by(group_id: @group.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a group with Ajax" do
    @user.follow(@group)
    relationship = @user.active_relationships.find_by(group_id: @group.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
