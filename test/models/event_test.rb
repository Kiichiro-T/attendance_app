require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:user1)
    @event = @user.events.build(event_name: "夏合宿",
                                start_date: 2.days.since.to_datetime,
                                end_date: 2.days.since.to_datetime,
                                memo:       "夏合宿は8/3~8/9です。",
                                url_token:  SecureRandom.hex(10) )
  end
  
  test "should be valid" do
    assert @event.valid?
  end

  test "user id should be present" do
    @event.user_id = nil
    assert_not @event.valid?
  end
  
  test "event_name should be present" do
    @event.event_name = "   "
    assert_not @event.valid?
  end

  test "event_name should be at most 50 characters" do
    @event.event_name = "a" * 51
    assert_not @event.valid?
  end
  
  test "start date should be present" do
    @event.start_date = "   "
    assert_not @event.valid?
  end
  
  test "end date should be present" do
    @event.end_date = "   "
    assert_not @event.valid?
  end
  
  test "memo should be at most 1024 characters" do
    @event.memo = "a" * 1025
    assert_not @event.valid?
  end
  
  test "order should be most recent first" do
    assert_equal events(:event_user1), Event.first
  end
  
  test "url_token should be present" do
    @event.url_token = "   "
    assert_not @event.valid?
  end
  
  test "url_token should be unique" do
    duplicate_event = @event.dup
    duplicate_event.url_token = @event.url_token
    @event.save
    assert_not duplicate_event.valid?
  end
  
  test "associated answers should be destroyed" do
    @event.save
    @event.answers.create!(status: 1, user_id: @event.user.id)
    assert_difference 'Answer.count', -1 do
      @event.destroy
    end
  end
end