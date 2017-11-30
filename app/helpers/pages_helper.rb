module PagesHelper

  ## 设置标题
  def title(pre_title = '')
    site_name = Siteinfo.first.blank? ?  "IT设备管理" : Siteinfo.first.title
    return site_name if pre_title.blank?
    pre_title + " · " + site_name
  end

  ## 注册登录页面标签切换
  # path: 标识当前页面(signup/signin)
  # text: 标签文本, 当text=path时, 显示css_class
  # css_class: 显示的样式
  def link_to_login(text, css_class, path)
    link_class = css_class	if text == path
    link_text = text
    link_to link_text, "#", class: link_class
  end

  # 只显示对应的注册登录表单
  def show_or_hidden_login_div(text, path)
    display_value = text == path ? "block" : "none"
    "style= 'display: #{display_value}'".html_safe
  end


end
