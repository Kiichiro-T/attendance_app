class EventsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_event,   only: [:edit, :update, :destroy]
  
  def index
    @answer = current_user.answers
    @events = Event.where
  end
  
  def show
    @event = Event.find_by(url_token: params[:url_token])
  end
  
  def new
    @event = Event.new  if logged_in?
  end
  
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "イベントが作成されました"
      redirect_to url_copy_url(url_token: @event.url_token)
    else
      @feed_items = []
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_params)
      flash[:success] = "イベントの編集に成功しました"
      redirect_to url_copy_url(url_token: @event.url_token)
    else
      render "edit"
    end
  end
  
  def destroy
    @event.destroy
    flash[:success] = "イベントを削除しました"
    redirect_to request.referrer || root_url
  end
  
  def url_copy
    @event  = Event.find_by(url_token: params[:url_token])
    @answer = current_user.answers.find_by(event_id: @event.id)
  end
  
  private
    
    def event_params
      params.require(:event).permit(:event_name, :start_date, :end_date, :memo, :picture, :url_token, :user_id, :group_id)
    end
    
    # ログイン中、本人しか操作できない
    def correct_user_event
      @event = current_user.events.find_by(url_token: params[:url_token])
      if @event.nil?
        flash[:danger] = "不正な操作です"
        redirect_to root_url
      end
    end
    
    
end
