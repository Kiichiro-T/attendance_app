class StaticPagesController < ApplicationController
   
  def home
    scope = Event.joins(:answers)
    id = current_user.id
    @not_answered_event = current_user.events.left_joins(:answers).where(answers: { id: nil }).paginate(page: params[:page]) if logged_in?
    @answered_events = scope.where("answers.user_id = ?", id).paginate(page: params[:page]) if logged_in?
  end

  def help
    
  end

  def about
  end
end
     
