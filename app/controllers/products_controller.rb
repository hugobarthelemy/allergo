class ProductsController < ApplicationController
  def index
    @products = policy_scope(Product)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
