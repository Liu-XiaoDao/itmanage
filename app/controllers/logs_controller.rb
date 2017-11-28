class LogsController < ApplicationController

  skip_around_action :writinglog, only: [:index, :search]

  layout 'home'

  def index
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

  def new
  end

  def edit
  end

  def update
  end

  def show
  end

  def create
  end
end
