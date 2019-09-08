require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @group = groups(:group1)
    @user  = users(:user3)
  end
  
  # showアクション
  test "should redirect show when not logged in" do
    get group_path(@group)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # newアクション
  test "should redirect new when not logged in" do
    get new_group_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # createアクション
  test "should redirect create when not logged in" do
    post groups_path, params: { group: { name: "テニス部", 
                                         explanation: "高校のテニス部です。" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # editアクション
  test "should redirect edit when not logged in" do
    get edit_group_path(@group)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not current user" do
    log_in_as(@user)
    get edit_group_path(@group)
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  # updateアクション
  test "should redirect update when not logged in" do
    patch group_path(@group), params: { group: { name: @group.name, 
                                                 explanation: @group.explanation,
                                                 user_id: @user.id } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not current user" do
    log_in_as(@user)
    patch group_path(@group), params: { group: { name: @group.name, 
                                                 explanation: @group.explanation,
                                                 user_id: @user.id} }
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  # destroyアクション
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete group_path(@group)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not current user" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete group_path(@group)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect followers when not logged in" do
    get followers_group_path(@group)
    assert_redirected_to login_url
  end
  
  test "should redirect followers when not belong to" do
    user = users(:user1)
    log_in_as(user)
    get followers_group_path(@group)
    assert_redirected_to root_url
  end
end
