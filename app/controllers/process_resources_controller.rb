class ProcessResourcesController < ApplicationController
  layout "home"
  def index
    @entryprocess = EntryProcess.find(params[:process_management_id])
    @process_resources = @entryprocess.process_resources.paginate page: params[:page], per_page: 50
  end

  def new
    @entryprocess = EntryProcess.find(params[:process_management_id])
    @process_resource = @entryprocess.process_resources.new
  end

  def create
    @entryprocess = EntryProcess.find(params[:process_management_id])
    @process_resource = @entryprocess.process_resources.new(resource_params)
    if @process_resource.save
      flash[:success] = "添加流程资源成功"
      redirect_to process_management_process_resources_path(@entryprocess)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private
    def resource_params
      params.require(:process_resource).permit(:resource_name,:default, :enable)
    end
end
