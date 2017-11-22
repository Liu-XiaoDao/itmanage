class ApplicationController < ActionController::Base
	include SessionsHelper

  	protect_from_forgery      #防止csrf的一会在研究

  	before_action :check_signed_in, :set_time_zone, :set_locale


  	# 确保已登录, 否则转向登录页面
	def check_signed_in
	    unless signed_in?
	      	flash[:warning] = "您还没有登录请先登录!"
	      	redirect_to signin_path
	    end
	end 


	# 设置时区
	def set_time_zone
	   Time.zone = 'Beijing'
	end


	# 设置语系
	def set_locale
		supported_locale = %w(zh-CN en)
		if params[:locale] && I18n.locale_available?( params[:locale].to_sym ) && supported_locale.include?( params[:locale] )
			cookies.permanent[:locale] = params[:locale]  #cookies.permanent  这个存储的值过期时间为20年，可以认为是永久
		end
		I18n.locale = cookies[:locale] || I18n.default_locale
	end



end
