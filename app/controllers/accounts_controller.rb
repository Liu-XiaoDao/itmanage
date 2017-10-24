class AccountsController < ApplicationController

    skip_before_action :check_signed_in, only: [:new, :create]      #整个系统都需要登录操作所以在application中设置,检测是都登录,但是在登录和注册页面需要跳过验证

    def new
        @user = User.new
        render layout: 'login'
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in @user     #用户名加入session
            redirect_to root_path
        else
            # if @user.errors.any?
            #    @user.errors.full_messages.each do |msg| 
            #       flash[:warning] = msg
            #    end 
            # end
            # render :new, layout: 'login'
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :email, :password)
        end
end
