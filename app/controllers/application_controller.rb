class ApplicationController < ActionController::Base
	include SessionsHelper, UsersHelper

  	protect_from_forgery      #防止csrf的一会在研究

  	before_action :check_signed_in, :set_time_zone, :set_locale, :check_auth
  	around_action :writinglog

  	# 确保已登录, 否则转向登录页面
	def check_signed_in
	    unless signed_in?
	      	flash[:warning] = "您还没有登录请先登录!"
	      	store_location    #如果没登录会跳转到登录页,在这保存原本想要访问的页面,登陆后返回
	      	redirect_to signin_path
			else
				User.current_user = current_user
	    end
	end


	# 设置时区   ,这个地方注释,有点问题,新的解决方法在,application.rb中
	def set_time_zone
	   # Time.zone = 'Beijing'
	end


	# 设置语系
	def set_locale
		supported_locale = %w(zh-CN en)
		if params[:locale] && I18n.locale_available?( params[:locale].to_sym ) && supported_locale.include?( params[:locale] )
			cookies.permanent[:locale] = params[:locale]  #cookies.permanent  这个存储的值过期时间为20年，可以认为是永久
		end
		I18n.locale = cookies[:locale] || I18n.default_locale
	end

	#使用中置方法记录一个请求是否成功
	def writinglog
		@log = Log.new
		@log.ip = request.remote_ip
		@log.controller = params[:controller]
		@log.action = params[:action]
		@log.params = params
		@log.success = false
		@log.save

		yield

		@log.success = true
		@log.save
	end


  def check_auth
		controller_name = params[:controller]
		action_name = params[:action]
    unless User::current_user.admin
	    unless User::current_user.rights.pluck(:right_name).include?("#{controller_name}@#{action_name}")
				redirect_to "/404.html"
	    end
		end
  end


end
