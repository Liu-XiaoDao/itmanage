class ProcessManagementsController < ApplicationController
  layout 'home'
  def index
    @entryprocess = EntryProcess.all.paginate page: params[:page], per_page: 50
  end

  def new
    @entryproces = EntryProcess.new
  end

  #入职流程
  def create
    #
    @entryproces = EntryProcess.new(process_params)
    #保存
    if @entryproces.save
      flash[:success] = "添加入职流程成功"
      redirect_to process_managements_path
    else
      render :new
    end
  end

  def edit
    @entryproces = EntryProcess.find(params[:id])
  end

  #入职流程
  def update
    #
    @entryproces = EntryProcess.find(params[:id])
    #保存
    if @entryproces.update(process_params)
      flash[:success] = "修改入职流程成功"
      redirect_to process_managements_path
    else
      render :edit
    end
  end

  def show
    @entryproces = EntryProcess.find(params[:id])
    @process_resources = @entryproces.process_resources
  end

  private
    def process_params
      params.require(:entry_process).permit(:process_name,:display_order, :responsible, :enable)
    end
end
