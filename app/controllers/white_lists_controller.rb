class WhiteListsController < ApplicationController
  skip_before_action :check_signed_in, only: [:display_list, :check_auth]
  layout 'home'
  def index
    @white_lists = WhiteList.all.paginate page: params[:page], per_page: 20
  end

  def new
    @white_list = WhiteList.new
  end

  def create
    @white_list = WhiteList.new(white_list_params)
    if @white_list.save
      flash[:success] = "白名单添加成功"
      redirect_to white_lists_path
    else
      render :new
    end
  end

  def edit
    @white_list = WhiteList.find(params[:id])
  end

  def show
    @white_list = WhiteList.find(params[:id])
  end

  def update
    @white_list = WhiteList.find(params[:id])
    if @white_list.update(white_list_params)
      flash[:success] = "白名单修改成功"
      redirect_to white_lists_path
    else
      render :edit
    end
  end

  def display_list
    @white_lists = WhiteList.all.paginate page: params[:page], per_page: 20
    render layout: false
  end

  def destroy
    @white_list = WhiteList.find(params[:id])
    @white_list.destroy
    flash[:success] = "用户删除成功"
    redirect_to white_lists_path
  end

  private
    def white_list_params
      params.require(:white_list).permit(:web_name, :url, :introduce, :requester, :is_add)
    end
end
