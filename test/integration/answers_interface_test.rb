require 'test_helper'

class AnswersInterfaceTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:user1)
    @event1 = events(:event_user1)
    @event2 = events(:event_user2)
    @answer = answers(:answer_event_user1)
  end

  test "event answers index" do
    log_in_as(@user)
    get event_answers_path(event_url_token: @event1.url_token)
    assert_template 'answers/index'
    assert_match "イベント名: #{@event1.event_name}", response.body
    assert_match "日付：", response.body
    assert_match "作成者： #{@user.name}", response.body
    assert_match @event1.answers.count.to_s, response.body
    assert_match "回答結果", response.body 
    assert_match "○", response.body
    first_page_of_answers = @event1.answers.paginate(page: 1)
    first_page_of_answers.each do |answer|
      assert_select "a[href=?]", user_path(id: answer.user.id), text: answer.user.name
      assert_select "div.answer_status"
      assert_select "span.timestamp"
    end
    assert_select 'div.pagination'
  end
  
  test "answers new and create" do
    log_in_as(@user)
    get new_event_answer_path(event_url_token: @event2.url_token)
    assert_template 'answers/new'
    # 無効な送信
    assert_no_difference 'Answer.count' do
      post event_answers_path(event_url_token: @event2.url_token), 
                                       params: { answer: { 
                                                 status: 2,
                                                user_id: "",
                                               event_id: ""} }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    assert_difference 'Answer.count', 1 do
      post event_answers_path(event_url_token: @event2.url_token), 
                                       params: { answer: { 
                                                 status: 3,
                                                 reason: "旅行",
                                                user_id: @user.id,
                                               event_id: @event2.id} }
    end
    assert_redirected_to event_answers_url(event_url_token: @event2.url_token)
    follow_redirect!
    assert_select 'a', text: @user.name
    assert_match "出欠状況", response.body
    assert_select 'span.timestamp'
  end
  
  test "answers edit and update" do
    log_in_as(@user)
    get root_url
    assert_select 'a', text: "回答変更"
    get edit_event_answer_path(event_url_token: @answer.event.url_token, id: @answer.id)
    assert_template 'answers/edit'
    # 無効な送信
    patch event_answer_path(event_url_token: @answer.event.url_token, id: @answer.id), 
                                     params: { answer: { status: 2,
                                                        user_id: "",
                                                       event_id: "" } }
    assert_select 'div#error_explanation'
    # 有効な送信
    status   = 3
    reason   = "旅行"
    user_id  = @answer.user_id
    event_id = @answer.event_id
    patch event_answer_path(event_url_token: @answer.event.url_token, id: @answer.id),
                                 params: { answer: { status: status,
                                                     reason: reason,
                                                    user_id: user_id,
                                                   event_id: event_id } }
    #assert_not flash.empty?
    #assert_redirected_to event_answers_url(event_url_token: @answer.event.url_token)
    @answer.reload
    #assert_equal status,   @answer.status
    #assert_equal reason,   @answer.reason
    #assert_equal user_id,  @answer.user_id
    #assert_equal event_id, @answer.event_id
  end
end
