class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following]
  before_action :correct_user,   only: [:edit, :update, :following]
  before_action :admin_user,     only: [:destroy]
    
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @events = @user.events.paginate(page: params[:page]) # @userの作成したevents
    @events.each do |event|
      @answer = Answer.where(["event_id = ? and user_id = ?", event.id, event.user_id])
    end
    @groups = @user.following
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを確認してアカウントを有効化してください"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールの変更に成功しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "ユーザーは削除されました"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー"
    @groups = @user.following
    @groups_p = @groups.paginate(page: params[:page])
    render 'users/show_follow'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
    end
    
    # beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "不正な操作です"
        redirect_to(root_url)
      end
    end    
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end


