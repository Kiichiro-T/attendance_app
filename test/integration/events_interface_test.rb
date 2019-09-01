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
                                           date: "",
                                           memo: "a" * 1025 } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    event_name = "練習"
    date = 1000.days.since.to_datetime
    memo = "テニスラケットが必要です。"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: { event_name: event_name,
                                           date:       date,
                                           memo:       memo,
                                           picture:    picture,
                                           url_token:  SecureRandom.hex(10),
                                           user_id:    @user.id} }
    end
    assert_redirected_to root_url
    follow_redirect!
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
    assert_select 'a', text: "回答変更"
    get edit_event_path(url_token: @event.url_token)
    # 無効な送信
    patch event_path(url_token: @event.url_token), 
                        params: { event: { event_name: "",
                                                 date: "",
                                                 memo: "a" * 1025 } }

    assert_select 'div#error_explanation'
     # 有効な送信
    event_name = "旅行"
    date = 1001.days.since.to_datetime
    memo = "テニスラケットは不要です。"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    url_token = SecureRandom.hex(10)
    patch event_path(url_token: @event.url_token), 
                        params: { event: { event_name: event_name,
                                                 date:       date,
                                                 memo:       memo,
                                              picture:    picture,
                                            url_token:  url_token,
                                              user_id:    @user.id} }
    @event.reload
    assert_not flash.empty?
    assert_redirected_to event_answers_url(event_url_token: @event.url_token)
    assert_equal event_name, @event.event_name
    #assert_equal date, @event.date
    assert_equal memo, @event.memo
    # 違うユーザーのプロフィールにアクセス（イベント編集リンクがないことを確認）
    get user_path(users(:user2))
    assert_select 'a', text: "イベント編集", count: 0
  end
end
