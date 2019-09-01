require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  def setup
    @event  = events(:event_user1)
    @answer = @event.answers.build(status:  3,
                                   reason:  "旅行のため",
                                   remarks: "特になし",
                                   user_id: @event.user.id)
  end
  
  #test "should be valid" do
  #  assert @answer.valid?
  #end
  
  test "status should be present" do
    @answer.status = nil
    assert_not @answer.valid?
  end
  
  #test "reason should be present unless status == 1" do
  #  unless @answer.status == 1
  #    @answer.reason = nil
  #    assert_not @answer.valid?
  #  end
  #end
  
  test "reason should be at most 1024 characters" do
    @answer.reason = "a" * 1025
    assert_not @answer.valid?
  end
  
  test "remarks should be at most 1024 characters" do
    @answer.remarks = "a" * 1025
    assert_not @answer.valid?
  end
  
  test "order should be most recent first" do
    assert_equal answers(:answer_event_user1), Answer.first
  end
    
end
