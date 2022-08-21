class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy get_path get_index update_filter ]
  before_action :get_path, only: %i[ show ]


  # GET /reports or /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1 or /reports/1.json
  def show
    @report.get_data
    @columns = @report.columns.order(:id)
    @fields = @columns.where active: true
    @printers = @report.printers.order(:id)
  end

  # GET /reports/new
  def new
    @report = Report.new
    @customer = Customer.find(params[:customer_id])
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)
    @report.customer_id = params[:customer_id]
    respond_to do |format|
      if @report.save
        format.html { redirect_to @report}
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
      if @report.update(report_params)
        format.html { redirect_to @report, notice: "Report was successfully updated." }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
  end

  def update_filter
    column = @report.columns.order(:id).find(report_params[:filter])
    index = @report.columns.order(:id).index(column)
    @report.update(filter: index)
    @report.get_filtered_data(index)
    redirect_to @report
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to @report.customer, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:name, :filter, :path, :customer_id, column_ids: [])
    end

    def get_path
      if @report.path.blank?
        require 'dialog_box'
        path = DIALOG_BOX.get_file_dialog
        @report.update(path: path)
      end
    end

    def get_index(index)
      puts index
      @report = Report.find(params[:id])
      
    end

end
