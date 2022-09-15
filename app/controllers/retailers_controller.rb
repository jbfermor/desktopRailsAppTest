class RetailersController < ApplicationController
  before_action :set_retailer, only: %i[ show edit update destroy ]

  # GET /retailers or /retailers.json
  def index
    @retailers = Retailer.all
  end

  # GET /retailers/1 or /retailers/1.json
  def show
    @shops = @retailer.shops
  end

  # GET /retailers/new
  def new
    @retailer = Retailer.new
  end

  # GET /retailers/1/edit
  def edit
    @customers = Customer.all
  end

  # POST /retailers or /retailers.json
  def create
    @retailer = Retailer.new(retailer_params)
    @retailer.customer_id = params[:customer_id]

    respond_to do |format|
      if @retailer.save
        format.html { redirect_to customer_path(params[:customer_id]), notice: "Retailer was successfully created." }
        format.json { render :show, status: :created, location: @retailer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @retailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retailers/1 or /retailers/1.json
  def update
    respond_to do |format|
      if @retailer.update(retailer_params)
        format.html { redirect_to retailer_url(@retailer), notice: "Retailer was successfully updated." }
        format.json { render :show, status: :ok, location: @retailer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @retailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retailers/1 or /retailers/1.json
  def destroy
    @retailer.destroy

    respond_to do |format|
      format.html { redirect_to customer_path(@retailer.customer), notice: "Retailer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def massive_upload 
    file_path = path_to_string(`python ./public/get_file_path.py`)
    if file_path != "NotChosen"
      require 'axlsx'
      doc = SimpleXlsxReader.open(file_path)
      data = doc.sheets.first.rows.drop(1)
      data.each do |row| 
        Retailer.create(name: row[0], email: row[1], customer_id: params[:customer_id])
      end
    end
    redirect_to customer_path(params[:customer_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retailer
      @retailer = Retailer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def retailer_params
      params.require(:retailer).permit(:name, :email, :customer_id)
    end
end
