class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @achievements = Achievement.public_access
  end

  def new
    @achievement = Achievement.new
  end

  def create
    @achievement = Achievement.new(achievement_params)
    if @achievement.save
      redirect_to achievement_url(@achievement), notice: "Achievement has been created"
    else
      render :new
    end
  end

  def update   
    @achievement = Achievement.find(params[:id])
    if @achievement.update(achievement_params)
      redirect_to achievement_url(@achievement), notice: "Achievement has been updated"
    else
      render :edit
    end
  end

  def edit
    @achievement = Achievement.find(params[:id])
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def destroy
    @achievement = Achievement.find(params[:id])
    @achievement.destroy
    redirect_to achievements_url
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :featured, :cover_image)
  end
end