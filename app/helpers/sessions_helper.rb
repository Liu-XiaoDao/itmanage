module SessionsHelper

  def sign_in(user)
    session[:username] = user.username
  end

  def signed_in?  #检测当前用户，返回是否登录
    !current_user.nil?
  end

  def current_user   #设置并返回当前用户
    if username = session[:username]
      @current_user ||= User.find_by username: username  # ||= 左侧有值就用，那就不用执行右边的方法来，左边无值就在取值
    elsif username = cookies.signed[:username]
      user = User.find_by username: username
      return nil unless user
      if user.authenticated? :remember, cookies.signed[:remember_token]
         sign_in user
         @current_user = user
      end
    end
    @current_user
  end


  def sign_out   #退出登录
    return unless signed_in?
    session.delete :username
    @current_user = nil
  end


end
