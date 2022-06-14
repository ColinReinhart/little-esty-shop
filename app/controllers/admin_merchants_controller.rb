class AdminMerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    if merchant.update(merchant_params)

        if params[:status].present?
          redirect_to merchants_path
          flash[:success] = "Merchant successfully updated!"
        else
          redirect_to "/admin/merchants/#{merchant.id}"
          flash[:success] = "Merchant successfully updated!"
        end

    else
        redirect_to "/admin/merchants/#{merchant.id}/edit"
        flash[:alert] = "Error: #{error_message(merchant.errors)}"
    end
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    redirect_to "/admin/merchants"
  end

  private
    def merchant_params
        params.permit(:name, :status)
    end
end
