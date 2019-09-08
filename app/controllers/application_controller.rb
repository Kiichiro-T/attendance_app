class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
      store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    # グループに所属しているかどうか確認、所属していたらtrue
    def belong_to_group
      group = Group.find(params[:id])
      unless current_user.following?(group)
        flash[:danger] = "フォローしていないグループにはアクセスできません"
        redirect_to root_url
      end
    end
end
