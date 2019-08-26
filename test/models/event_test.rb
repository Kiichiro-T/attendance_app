require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @event = @user.events.build(event: "夏合宿", date: Date.today, memo: "夏合宿は8/3~8/9です。")
  end
  
  test "should be valid" do
    assert @event.valid?
  end

  test "user id should be present" do
    @event.user_id = nil
    assert_not @event.valid?
  end
  
  test "event should be present" do
    @event.event = "   "
    assert_not @event.valid?
  end

  test "event should be at most 50 characters" do
    @event.event = "a" * 51
    assert_not @event.valid?
  end
  
  test "date should be present" do
    @event.date = "   "
    assert_not @event.valid?
  end
  
  test "memo should be at most 1024 characters" do
    @event.memo = "a" * 1025
    assert_not @event.valid?
  end
  
  test "order should be most recent first" do
    assert_equal events(:most_recent), Event.first
  end
  
end
