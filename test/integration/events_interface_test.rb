require 'test_helper'

class EventsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:user1)
    @event = @user.events.paginate(page: 1).first
  end
  
  test "events new, create and destroy" do
    log_in_as(@user)
    get new_event_path # eventのnewページ
    assert_template 'events/new'
    assert_select 'input[type=file]'
    # 無効な送信
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { event_name: "",
                                           start_date: "",
                                           end_date: "",
                                           memo: "a" * 1025 } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    event_name = "練習"
    start_date = 1000.days.since.to_datetime
    end_date   = 1000.days.since.to_datetime
    memo = "テニスラケットが必要です。"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    url_token = SecureRandom.hex(10)
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: { event_name: event_name,
                                           start_date: start_date,
                                           end_date:   end_date,
                                           memo:       memo,
                                           picture:    picture,
                                           url_token:  url_token,
                                           user_id:    @user.id} }
    end
    assert_redirected_to url_copy_url(url_token: url_token)
    follow_redirect!
    get root_url
    #assert_match event_name, response.body まだ未回答のものを表示できていない
    # イベントを削除する
    assert_select 'a', text: "削除"
    assert_difference 'Event.count', -1 do
      delete event_path(url_token: @event.url_token)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:user2))
    assert_select 'a', text: "削除", count: 0
  end
  
  
  test "events edit and update" do
    log_in_as(@user)
    get root_url
    assert_select 'a', text: "イベント編集"
    get edit_event_path(url_token: @event.url_token)
    assert_template 'events/edit'
    # 無効な送信
    patch event_path(url_token: @event.url_token), 
                        params: { event: { event_name: "",
                                                 start_date: "",
                                                 end_date: "",
                                                 memo: "a" * 1025 } }

    assert_select 'div#error_explanation'
    # 有効な送信
    event_name = "旅行"
    start_date = 1000.days.since.to_datetime
    end_date   = 1000.days.since.to_datetime
    memo = "テニスラケットは不要です。"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    url_token = SecureRandom.hex(10)
    user_id = @user.id
    patch event_path(url_token: @event.url_token), 
                        params: { event: { event_name: event_name,
                                           start_date: start_date,
                                             end_date:   end_date,
                                                 memo:       memo,
                                              picture:    picture,
                                            url_token:  url_token,
                                              user_id:    user_id} }
    @event.reload
    assert_not flash.empty?
    assert_redirected_to url_copy_url(url_token: url_token)
    follow_redirect!
    get event_answers_path(event_url_token: @event.url_token)
    assert_equal event_name, @event.event_name
    #assert_equal date, @event.date
    assert_equal memo, @event.memo
    assert_equal url_token, @event.url_token
    assert_equal user_id, @event.user_id
    # 違うユーザーのプロフィールにアクセス（イベント編集リンクがないことを確認）
    get user_path(users(:user2))
    assert_select 'a', text: "イベント編集", count: 0
  end
  
  test "should not created_at date < today" do
    assert_no_difference 'Event.count' do
      post events_path, params: { event: { event_name: "example event",
                                           start_date: 2.days.ago.to_datetime,
                                           end_date:   2.days.ago.to_datetime,
                                           memo: "楽しみましょう！" } }
    end
  end
  
  
end
