require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @event = events(:summer)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { event_name: "example event",
                                           date: DateTime.now.to_datetime,
                                           memo: "楽しみましょう！" } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Event.count' do
      delete event_path(@event, url_token: @event.url_token)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    event = events(:fall)
    assert_no_difference 'Event.count' do
      delete event_path(event, url_token: event.url_token)
    end
    assert_redirected_to root_url
  end
end
