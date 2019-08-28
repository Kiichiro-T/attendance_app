require 'test_helper'

class EventsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "event interface" do
    log_in_as(@user)
    get new_event_path
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
    date = DateTime.now.to_datetime
    memo = "テニスラケットが必要です。"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: { event_name: event_name,
                                           date:       date,
                                           memo:       memo,
                                           picture:    picture } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match event_name, response.body
    # 投稿を削除する
    assert_select 'a', text: "削除"
    first_event = @user.events.paginate(page: 1).first
    assert_difference 'Event.count', -1 do
      delete event_path(first_event, url_token: first_event.url_token)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: "削除", count: 0
  end
end
