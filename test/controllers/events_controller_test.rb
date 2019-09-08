require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user   = users(:user1)
    @event  = events(:event_user1)
    @event2 = events(:event_user2)
  end
  
  test "should redirect new when not logged in" do
    get new_event_path
    assert_redirected_to login_url
  end
    
  test "should redirect create when not logged in" do
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { event_name: "example event",
                                           start_date: 2.days.since.to_datetime,
                                           end_date:   2.days.since.to_datetime,
                                           memo: "楽しみましょう！" } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get edit_event_path(url_token: @event.url_token)
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch event_path(url_token: @event.url_token), 
                        params: { event: { event_name: "example event",
                                                 start_date: 2.days.since.to_datetime,
                                                 end_date:   2.days.since.to_datetime,
                                                 memo: "楽しみましょう！" } }
    assert_redirected_to login_url
  end
  
  test "should redirect update for wrong event" do
    log_in_as(@user)
    patch event_path(url_token: @event2.url_token), 
                              params: { event: { event_name: "example event",
                                                      start_date: 2.days.since.to_datetime,
                                                      end_date:   2.days.since.to_datetime,
                                                      memo: "楽しみましょう！",
                                                      url_token: @event2.url_token,
                                                      group_id: 1} }
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Event.count' do
      delete event_path(url_token: @event.url_token)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong event" do
    log_in_as(@user)
    assert_no_difference 'Event.count' do
      delete event_path(url_token: @event2.url_token)
    end
    assert_redirected_to root_url
  end
end
