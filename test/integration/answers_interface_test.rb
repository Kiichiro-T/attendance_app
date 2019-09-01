require 'test_helper'

class AnswersInterfaceTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @event = events(:event_user1)
  end

  test "event answers index" do
    get event_answers_path(event_url_token: @event.url_token)
    assert_template 'answers/index'
    assert_select 'title', full_title("#{@event.event_name}の回答一覧")
    assert_match @event.answers.count.to_s, response.body
    assert_select 'div.pagination'
  end
end
