require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @event  = events(:event_user1)
    @answer = answers(:answer_event_user1)
  end
  
  test "should redirect index when not logged in" do
    get event_answers_path(event_url_token: @event.url_token)
    assert_redirected_to login_url
  end
  
  test "should redirect new when not logged in" do
    get new_event_answer_path(event_url_token: @event.url_token)
    assert_redirected_to login_url
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Answer.count' do
      post event_answers_path(event_url_token: @answer.event.url_token),
                                       params: { answer: { 
                                                 status: 1,
                                                user_id: User.last,
                                               event_id: 1} }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get edit_event_answer_path(event_url_token: @answer.event.url_token, id: @answer.id)
    assert_redirected_to login_url
  end
  
  test "should redirect edit for wrong event" do
    log_in_as(users(:user1))
    answer = answers(:answer_event_user2)
    get edit_event_answer_path(event_url_token: answer.event.url_token, id: answer.id)
    assert_redirected_to root_url
  end
  
   test "should redirect update when not logged in" do
    assert_no_difference 'Answer.count' do
      patch event_answer_path(event_url_token: @answer.event.url_token, id: @answer.id), 
                                       params: { answer: { 
                                                 status: 1,
                                                user_id: User.first,
                                               event_id: 1} }
    end
    assert_redirected_to login_url
  end
  
   test "should redirect update for wrong event" do
    log_in_as(users(:user1))
    answer = answers(:answer_event_user2)
    assert_no_difference 'Answer.count' do
      patch event_answer_path(event_url_token: answer.event.url_token, id: answer.id),
                                      params: { answer: { 
                                                 status: 1,
                                                user_id: User.first,
                                               event_id: answer.id} }
    end
    assert_redirected_to root_url
  end
  
end
