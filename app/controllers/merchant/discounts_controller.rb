class Merchant::DiscountsController < ApplicationController

  def index
    @discounts = Merchant.find(current_user.merchant.id).discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @discount = merchant.discounts.create(discount_params)
    if @discount.save 
      flash[:success] = "#{@discount.name} has been created."
      redirect_to "/merchant/discounts"
    else  
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchant/#{merchant.id}/discounts/new"
    end
  end

  def edit 
    @discount_id = params[:id]
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

  def destroy
    discount = Discount.find_by(id: params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"  
  end

  private

  def discount_params
    params.permit(:name, :percentage, :min_items, :description)
  end
end