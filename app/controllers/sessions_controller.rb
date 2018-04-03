class SessionsController < ApplicationController

  skip_before_action :check_signed_in, only: [:new, :create]      #整个系统都需要登录操作所以在application中设置,检测是都登录,但是在登录和注册页面需要跳过验证

  layout 'home'

  def new
    # 注册/登录同页面, 同时使用User_Model中的验证返回信息
    @user = User.new
  end

  def create
    if params.has_key?(:user_form)
        @user = User.find_by email: session_param(:email)
        if @user && @user.compare(session_param(:password))
            sign_in @user     #用户名加入session
            remember_me(@user)
            redirect_back_or root_path
        elsif @user
          # 密码错误
          @user.errors.add :password, "密码错误"
        else
          flash[:warning] = "没有此用户"
          redirect_to signin_path
        end
    else
        @user = User.from_omniauth(request.env["omniauth.auth"])      #这是通过ldap认证后,返回邮箱,再用邮箱找到用户,在返回用户
        sign_in @user
        remember_me(@user)
        redirect_back_or root_path
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

  private
    def session_param(attribute)
      params[:session][attribute]
    end
end
