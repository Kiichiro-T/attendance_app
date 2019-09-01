require 'test_helper'

class AnswersInterfaceTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:user1)
    @event = events(:event_user1)
  end

  test "event answers index" do
    log_in_as(@user)
    get event_answers_path(event_url_token: @event.url_token)
    assert_template 'answers/index'
    assert_match "イベント名: #{@event.event_name}", response.body
    assert_match "日付：", response.body
    assert_match "作成者： #{@user.name}", response.body
    assert_match @event.answers.count.to_s, response.body
    assert_match "回答結果", response.body 
    assert_match "○", response.body
    first_page_of_answers = @event.answers.paginate(page: 1)
    first_page_of_answers.each do |answer|
      assert_select "a[href=?]", user_path(id: answer.user.id), text: answer.user.name
      assert_select "div.answer_status"
      assert_select "span.timestamp"
    end
    assert_select 'div.pagination'
  end
end
