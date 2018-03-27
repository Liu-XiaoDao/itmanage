class SuppliersController < ApplicationController
  layout 'home'
  def index
    @suppliers = Supplier.all.paginate page: params[:page], per_page: 20
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:success] = "供应商添加成功"
      redirect_to suppliers_path
    else
      render :new
    end
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update(supplier_params)
      flash[:success] = "供应商修改成功"
      redirect_to suppliers_path
    else
      render :edit
    end
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy
    flash[:success] = "用户删除成功"
    redirect_to suppliers_path
  end

  private
    def supplier_params
      params.require(:supplier).permit(:product_name, :supplier_name, :contact, :contact_information, :note)
    end
end
