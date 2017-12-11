class LogsController < ApplicationController
  #查看日志的时候,不用再记录日志
  skip_around_action :writinglog, only: [:index, :search]

  layout 'home'

  def index
    #拿到所有日志
    @logs = Log.order(created_at: :desc).paginate page: params[:page], per_page: 20
  end

  #分别返回成功或者失败的日志
  def search
    @status = params[:log][:status]
    if @status.blank?
      @logs = Log.order(created_at: :desc).paginate page: params[:page], per_page: 20
    else
      @logs = Log.where(success: @status).order(created_at: :desc).paginate page: params[:page], per_page: 20
    end
    render "index"
  end
end
#check完成