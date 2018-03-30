class UserModelConfigsController < ApplicationController

  def index
    @user_model_configs = UserModelConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_model_configs }
    end
  end


  # def show
  #   @user_model_config = UserModelConfig.find(params[:id])
  #
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @user_model_config }
  #   end
  # end

  #
  # def new
  #   @user_model_config = UserModelConfig.new
  #
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @user_model_config }
  #   end
  # end

  # def edit
  #   @user_model_config = UserModelConfig.find(params[:id])
  # end

  def create
    @user_model_config = UserModelConfig.new
    @user_model_config.user_id = params[:user_model_config][:user_id]
    @user_model_config.model = params[:user_model_config][:model]
    fields_text = params[:user_model_config][:fields_text].present? ? params[:user_model_config][:fields_text].join(',') : ""
    @user_model_config.fields_text = fields_text

    respond_to do |format|
      if @user_model_config.save
        format.html { flash[:success] = "统计分类选择成功";redirect_to request.referer }
        format.json { render json: @user_model_config, status: :created, location: @user_model_config }
      else
        format.html { render action: "new" }
        format.json { render json: @user_model_config.errors, status: :unprocessable_entity }
      end
    end
  end

  def update


    @user_model_config = UserModelConfig.find(params[:id])
    @user_model_config.user_id = params[:user_model_config][:user_id]
    @user_model_config.model = params[:user_model_config][:model]
    fields_text = params[:user_model_config][:fields_text].present? ? params[:user_model_config][:fields_text].join(',') : ""
    @user_model_config.fields_text = fields_text

    respond_to do |format|
      if @user_model_config.save
        format.html { flash[:success] = "统计分类选择成功";redirect_to request.referer }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_model_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #   @user_model_config = UserModelConfig.find(params[:id])
  #   @user_model_config.destroy
  #
  #   respond_to do |format|
  #     format.html { redirect_to user_model_configs_url }
  #     format.json { head :no_content }
  #   end
  # end


end
