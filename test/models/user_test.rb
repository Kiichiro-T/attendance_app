require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "password", password_confirmation: "password")
    @user1  = users(:user1)
    @event1 = events(:event_user1)
    @group = groups(:group1)
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "      "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid adresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
                        first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid? "#{valid_adress.inspect} should be valid"
    end
  end
  
  test "email validation should not accept invalid adresses" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adress.inspect} should be invalid"
    end
  end
  
  test "email adress should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email adress should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated events should be destroyed" do
    @user.save
    @user.events.create!(event_name: "夏合宿", 
                         start_date: 10.days.since.to_datetime, 
                         end_date:   10.days.since.to_datetime, 
                         memo: "夏合宿は8/3~8/9です。",
                         url_token: SecureRandom.hex(10),
                         group_id: @group.id)
    assert_difference 'Event.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a group" do
    user  = users(:user1)
    group = groups(:group1)
    assert_not user.following?(group)
    user.follow(group)
    assert user.following?(group)
    assert group.followers.include?(user)
    user.unfollow(group)
    assert_not user.following?(group)
  end

=begin
  test "feed should have the right events" do
    user  = users(:user1)
    group1 = groups(:group1)
    group2 = groups(:group2)
    # フォローしているユーザーのイベントを確認
    group2.followers.each do |user_following|
      user_following.events.each do |event_following|
        assert user.feed.include?(event_following)
      end
    end
    # 自分自身のイベントを確認
    user.events.each do |event_self|
      assert user.feed.include?(post_self)
    end
    # フォローしていないユーザーのイベントを確認
    group1.followers.each do |user_unfollowed|
      user_unfollowed.events.each do |event_unfollowed|
        assert_not user.feed.include?(post_unfollowed)
      end
    end
  end
=end
end
