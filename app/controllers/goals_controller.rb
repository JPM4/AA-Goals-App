class GoalsController < ApplicationController
  before_action :ensure_logged_in

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to @goal
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    if @goal.destroy
      redirect_to current_user
    else
      flash[:errors] = ["No such goal"]
      redirect_to current_user
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to @goal
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end


  def show
    @goal = Goal.find(params[:id])
    unless @goal.user == current_user
      redirect_to current_user
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:body, :user_id, :priv, :status)
  end
end
