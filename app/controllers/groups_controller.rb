class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :belong_to_group,    only: [:followers]
  before_action :correct_user_group, only: [:edit, :update, :destroy]
  
  def index
  end
  
  def show
    @group = Group.find(params[:id])
    @events = Event.where("group_id = ?", @group.id)
    @users = @group.followers
    @user  = User.find_by(id: @group.user_id)
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save
      current_user.follow(@group)
      flash[:info] = "グループを作成しました"
      redirect_to @group
    else
      render 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash[:success] = "グループの設定を変更しました"
      redirect_to @group
    else
      render 'edit'
    end
  end
  
  # まだ実装していない
  def destroy
    @group = Group.find(params[:id]).destroy
    flash[:success] = "グループは削除されました"
    redirect_to root_url
  end
  
  def followers
    @title = "フォロワー"
    @group = Group.find(params[:id])
    @users = @group.followers
    @users_p = @users.paginate(page: params[:page])
    render 'groups/show_follow'
  end
  
  private
  
    def group_params
      params.require(:group).permit(:name, :explanation, :user_id)
    end
    
    # ログイン中、本人しか操作できない
    def correct_user_group
      @group = Group.find(params[:id])
      unless current_user.id == @group.user_id
        flash[:danger] = "不正な操作です"
        redirect_to root_url
      end
    end
end
