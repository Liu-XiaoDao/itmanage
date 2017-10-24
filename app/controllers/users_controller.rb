class UsersController < ApplicationController

  layout 'home'

  def index
  	@users = User.all
  end

  def edit
  	@user = User.find(params[:id])
  end

  def show
  	@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)

    render :edit
  end

  def updatepw    #管理员修改密码
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    @user.save
  end

  def upload_avatar
    @user = User.find(params[:id])
    @user.avatar_upload(params[:user][:avatar])

    redirect_to edit_user_path(@user)
  end

  private
    def user_params
      params.require(:user).permit(:username, :nickname, :email)
    end
end
