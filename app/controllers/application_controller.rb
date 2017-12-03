class ApplicationController < ActionController::Base
	include SessionsHelper, UsersHelper

  	protect_from_forgery      #防止csrf的一会在研究

  	before_action :check_signed_in, :set_time_zone, :set_locale
  	around_action :writinglog

  	# 确保已登录, 否则转向登录页面
	def check_signed_in
	    unless signed_in?
	      	flash[:warning] = "您还没有登录请先登录!"
	      	store_location    #如果没登录会跳转到登录页,在这保存原本想要访问的页面,登陆后返回
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


	  #分类缩进
    def GetTree(arr,pid,step,newarr,indentstr)
	  	for item in arr
		   if item['parent_id'] == pid
	            indent = indentstr * step
	            item['name'] = indent + item['name']
	            newarr.push item
	            GetTree(arr , item['id'] ,step+1,newarr,indentstr)
	        end
		end
    end

    #导出报表
    def export_csv(model)
      respond_to { |format|
        format.html 
        format.csv { send_data model.to_csv }
      }
    	
    end


end
