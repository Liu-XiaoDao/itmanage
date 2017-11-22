module HomeHelper
	#当前所在类别激活
	def check_if_active(text,path)
		text == path ? "active" : ""
	end
	## 切换语系
	def link_to_locale(path)
		link_text = I18n.t(:lang) == "EN" ? "中文" : "EN"
		link_url = I18n.t(:lang) == "EN" ? path + "?locale=zh-CN" : path + "?locale=en"
		link_to content_tag(:span, '', class: "glyphicon glyphicon-retweet")+" "+link_text, link_url
	end

end
