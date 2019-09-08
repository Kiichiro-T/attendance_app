require 'test_helper'

class GroupsInterfaceTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @event = @user.events.paginate(page: 1).first
    @group = groups(:group1)
  end
  
  test "groups new, create, followers, edit, update" do
    log_in_as(@user)
    get new_group_path
    assert_template 'groups/new'
    # 無効な送信
    assert_no_difference 'Group.count' do
      post groups_path, params: { group: { name: "",
                                           explanation: "",
                                           user_id: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    name = "硬式テニス部"
    explanation = "都立○○高校の硬式テニス部です。"
    user_id = @user.id
    assert_difference 'Group.count', 1 do
      post groups_path, params: { group: { name: name,
                                           explanation: explanation,
                                           user_id: user_id } }
    end
    group = Group.last
    assert_redirected_to group_path(id: group.id)
    follow_redirect!
    assert_select 'a', text: "#{group.followers.count}人"
    get edit_group_path(id: group.id)
    assert_template 'groups/edit'
    # 無効な送信
    patch group_path(id: group.id), params: { group: { name: "",
                                                explanation: "",
                                                user_id: "" } }
    assert_select 'div#error_explanation'
    # 有効な送信
    name = "軟式テニス部"
    explanation = "都立○○高校の軟式テニス部です。"
    patch group_path(id: group.id), params: { group: { name: name,
                                                explanation: explanation,
                                                user_id: user_id } }
    group.reload
    assert_not flash.empty?
    assert_redirected_to group_path(id: group.id)
    assert_equal name, group.name
    assert_equal explanation, group.explanation
  end
  
  test "groups folowers when wrong user log in" do
    log_in_as(@user)
    get group_path(@group)
    assert_select 'a', text: "#{@group.followers.count}人", count: 0
  end
    
end
