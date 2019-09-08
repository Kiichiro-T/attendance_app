class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @group = Group.find(params[:group_id])
    current_user.follow(@group)
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  def destroy
    @group = Relationship.find(params[:id]).group
    current_user.unfollow(@group)
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end
end
