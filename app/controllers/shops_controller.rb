class ShopsController < ApplicationController
  before_action :set_shop, only: %i[ show edit update destroy ]

  # GET /shops or /shops.json
  def index
    @shops = Shop.all
  end

  # GET /shops/1 or /shops/1.json
  def show
  end

  # GET /shops/new
  def new
    @shop = Shop.new
    @retailers = Customer.find(params[:customer_id]).retailers
  end

  # GET /shops/1/edit
  def edit
    @retailers = @shop.retailer.customer.retailers
  end

  # POST /shops or /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to shop_url(@shop), notice: "Shop was successfully created." }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1 or /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to shop_url(@shop), notice: "Shop was successfully updated." }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  def massive_upload 
    file_path = path_to_string(`python ./public/get_file_path.py`)
    if file_path != "NotChosen"
      require 'axlsx'
      doc = SimpleXlsxReader.open(file_path)
      data = doc.sheets.first.rows.drop(1)
      data.each do |row| 
        Shop.create(name: row[0], email: row[1], retailer_id: Retailer.find_by(name: row[2]).id)
      end
    end
    redirect_to customer_path(params[:customer_id])
  end

  # DELETE /shops/1 or /shops/1.json
  def destroy
    customer = @shop.retailer.customer
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to customer, notice: "Shop was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :email, :retailer_id)
    end
end
