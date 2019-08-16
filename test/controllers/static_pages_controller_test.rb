require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @basetitle = "AA"
  end
  
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@basetitle}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "ヘルプ | #{@basetitle}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "このサイトについて | #{@basetitle}"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "お問い合わせ | #{@basetitle}"
  end
  
  test "should get signup" do
    get signup_path
    assert_response :success
    assert_select "title", "サインアップ | #{@basetitle}"
  end
end
