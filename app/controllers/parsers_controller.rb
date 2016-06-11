class ParsersController < ApplicationController
  def index
  end

  def create
    Product.save(params[:url])    
    redirect_to root_path
  end
end
