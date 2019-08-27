require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title("マイページ")
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match  @user.events.count.to_s, response.body
    assert_select 'div.pagination'
    @user.events.paginate(page: 1).each do |event|
      assert_match event.event_name, response.body
      d = event.date
      wd = ["日", "月", "火", "水", "木", "金", "土"]
      assert_match d.strftime("%Y/%m/%d(#{wd[d.wday]})"), response.body
    end
  end
end
