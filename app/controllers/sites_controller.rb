class SitesController < ApplicationController
  layout 'home'
  #修改的那页
  def show
    @siteinfo = Siteinfo.first.blank? ?  Siteinfo.new : Siteinfo.first
  end

  def update
    @siteinfo = Siteinfo.first
    @siteinfo.title = params[:siteinfo][:title]
    @siteinfo.emailrecive = params[:siteinfo][:emailrecive]
    if @siteinfo.save
      flash[:success] = "修改成功"
      redirect_to site_path
    else
      flash[:danger] = "修改失败"
      redirect_to site_path
    end
  end

  def create
    @siteinfo = Siteinfo.new
    @siteinfo.title = params[:siteinfo][:title]
    @siteinfo.emailrecive = params[:siteinfo][:emailrecive]
    if @siteinfo.save
      flash[:success] = "修改成功"
      redirect_to site_path
    else
      flash[:danger] = "修改失败"
      redirect_to site_path
    end
  end

end
