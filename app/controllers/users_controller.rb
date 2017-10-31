class UsersController < ApplicationController

  layout 'home'

  def index
  	@users = User.all.paginate page: params[:page], per_page: 10
    @departments = Department.all
  end
  
  def search
    # @users = User.where(username: params[:username]).paginate page: params[:page], per_page: 10
    # return render plain: params[:user][:username] + params[:user][:email] + params[:user][:created_at] + params[:user][:department]
    @username = params[:user][:username]
    @email = params[:user][:email]
    @created_at = params[:user][:created_at]
    @department = params[:user][:department]

    @users = User.where("username = ? or email = ? or created_at = ? or department = ?",@username,@email,@created_at,@department).paginate page: params[:page], per_page: 1
    @departments = Department.all
    render "index"    
  end

  def edit
    @user = User.find(params[:id])
    @decategorys = Decategory.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: user_params
    else
      @user.errors.full_messages.each do |msg|
        render plain: msg
      end
    end
#    render :edit
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
