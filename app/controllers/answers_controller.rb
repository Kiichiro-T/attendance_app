class AnswersController < ApplicationController
  before_action :logged_in_user
  before_action :set_event
  before_action :status_count,   only: [:index]
  before_action :correct_user_answer, only: [:edit, :update]
  
  def index
    @user  = User.find_by(id: @event.user_id)
    @group = Group.find(@event.group_id)
  end
  
  def new
    @answer = Answer.new
  end
  
  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      flash[:success] = "回答できました"
      redirect_to event_answers_url(event_url_token: @event.url_token)
    else
      render 'answers/new'
    end
  end
  
  def edit
  end
  
  def update
    if @answer.update_attributes(answer_params)
      flash[:success] = "回答の変更に成功しました"
      redirect_to event_answers_url(event_url_token: @event.url_token)
    else
      render "answers/edit"
    end
  end
  
  private
  
    def answer_params
      params.require(:answer).permit(:status, :reason, :remarks, :user_id, :event_id)
    end
    
    def set_event
      @event = Event.find_by(url_token: params[:event_url_token])
    end
    
    # 各statusの数を返す
    def status_count
      if @event
       @answers = @event.answers.paginate(page: params[:page])
        if @answers
          status_1 = @answers.where("status = ?", 1)
          status_2 = @answers.where("status = ?", 2)
          status_3 = @answers.where("status = ?", 3)
          @s_1_count = status_1.present? ? status_1.count : "0"
          @s_2_count = status_2.present? ? status_2.count : "0"
          @s_3_count = status_3.present? ? status_3.count : "0"
        end
      end
    end
    
    # ユーザーがログイン中ならばそのanswerを返す
    def correct_user_answer
      @answer = current_user.answers.find_by(id: params[:id], event_id: @event.id)
      if @answer.nil?
        flash[:danger] = "不正な操作です"
        redirect_to root_url
      end
    end
      
    
=begin
    # ユーザー
    def has_answered?
      @answer = Answer.find_by(id: params[:id])
      @event  = Event.find_by(url_token: params[:event_url_token])
      if  @answer && @answer.hasAnswered
        true
      else
        redirect_to new_event_answer_url(event_url_token: @event.url_token)
        flash[:danger] = "まずはこのページで回答してください"
      end
    end
=end
  
  
end
