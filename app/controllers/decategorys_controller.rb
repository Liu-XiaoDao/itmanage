class DecategorysController < ApplicationController
  layout 'home'

  def index
    @decategorys = Decategory.all.paginate page: params[:page], per_page: 10
  end

  def new
    @decategory = Decategory.new
  end

  def create

    @decategory = Decategory.new(decategory_params)
    if @decategory.save
      redirect_to decategorys_path
    else
      render :new
    end

  end

  def show
  end

  def update
  end

  def edit
  end

  private 
      def decategory_params
        params.require(:decategory).permit(:name)
      end
end
