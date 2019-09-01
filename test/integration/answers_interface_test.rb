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
    assert_match @event.answers.count.to_s, response.body
    assert_select 'div.pagination'
  end
end
