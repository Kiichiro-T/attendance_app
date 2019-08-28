class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :set_event,      only: :show
  
  def new
    @event = current_user.events.build  if logged_in?
  end
  
  def show
  end 
  
  def create
    @event = current_user.events.build(event_params)
    if @event.save
      flash[:success] = "イベントが作成されました"
      redirect_to root_url
    else
      @feed_items = []
      render 'events/new'
    end
  end
  
  def destroy
    @event.destroy
    flash[:success] = "イベントを削除しました"
    redirect_to request.referrer || root_url
  end
  
  private
    
    def event_params
      params.require(:event).permit(:event_name, :date, :memo, :picture, :url_token)
    end
    
    def correct_user
      @event = current_user.events.find_by(url_token: params[:url_token])
      redirect_to root_url if @event.nil?
    end
    
    def set_event
      @event = Event.find_by(url_token: params[:url_token])
    end
    
    
end
