class EventsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_event,   only: [:edit, :update, :destroy]
  before_action :set_event,      only: :show
  
  def new
    @event = Event.new  if logged_in?
  end
  
  def show
  end 
  
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "イベントが作成されました"
      redirect_to root_url
    else
      @feed_items = []
      render 'events/new'
    end
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_params)
      flash[:success] = "イベントの編集に成功しました"
      redirect_to event_answers_url(event_url_token: @event.url_token)
    else
      render "events/edit"
    end
  end
  
  def destroy
    @event.destroy
    flash[:success] = "イベントを削除しました"
    redirect_to request.referrer || root_url
  end
  
  private
    
    def event_params
      params.require(:event).permit(:event_name, :date, :memo, :picture, :url_token, :user_id)
    end
    
    # ログイン中、本人しか操作できない
    def correct_user_event
      @event = current_user.events.find_by(url_token: params[:url_token])
      if @event.nil?
        flash[:danger] = "不正な操作です"
        redirect_to root_url
      end
    end
    
    def set_event
      @event = Event.find_by(url_token: params[:url_token])
    end
    
    
end
