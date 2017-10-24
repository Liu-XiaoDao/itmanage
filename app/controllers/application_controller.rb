class ApplicationController < ActionController::Base
	include SessionsHelper

  	protect_from_forgery      #防止csrf的一会在研究

  	before_action :check_signed_in


  	# 确保已登录, 否则转向登录页面
	def check_signed_in
	    unless signed_in?
	      	flash[:warning] = "您还没有登录清闲登录!"
	      	redirect_to signin_path
	    end
	end 



end
