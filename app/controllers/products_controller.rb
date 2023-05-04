class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy deactivate ]

  # GET /products
  def index
    @products = SearchTerm
      .new(resource: Product, column: :name, term: params[:term])
      .call

    render json: @products.page(params[:page])
  end

  # GET /products/1
  def show
    return render json: { message: 'Not found' }, status: :not_found if @product.nil?

    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  # PUT /products/1/deactivate
  def deactivate
    Product
      .find(params[:product_id])
      .update(status: :deactive)

    render json: @product
  end

  private

    def set_product
      @product = Product.find_by(id: params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :photo_url, :status)
    end
end
