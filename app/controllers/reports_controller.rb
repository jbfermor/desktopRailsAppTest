class ReportsController < ApplicationController
  before_action :set_report, except: %i[ index new create ]

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
    column = @report.columns.where.order(:id).find(report_params[:filter])
    index = @report.columns.order(:id).index(column)
    @report.update(filter: index)
    @report.get_filtered_data(index)
    redirect_to @report
  end

  def report_create
    report_path = report_params[:report_path]
    @report.update(report_path: report_path)
    redirect_to @report
  end

  def print_report
    require 'axlsx'
    printers = @report.printers.where(active: true)
    data = SimpleXlsxReader.open(@report.report_path)
    folder_path = get_folder_path[0..-2]
    @report.update(path: folder_path)
    printers.each do |printer|
      make_report(printer, folder_path, data)
    end
    redirect_to @report
  end

  def print_send_report
    @active_printers = @report.printers.where active: true
    @accounts = `python ./public/get_mail_accounts.py`.split
    require 'axlsx'
    data = SimpleXlsxReader.open(@report.report_path)
    folder_path = get_folder_path[0..-2]
    @report.update(path: folder_path)
    @active_printers.each do |printer|
      make_report(printer, folder_path, data)
    end
  end

  def final_sending
    printers = @report.printers.where(active: true)
    printers.each do |printer|
      mail = Shop.all.find_by(name: printer.name).email
      puts `python ./public/send_report.py #{params[:accounts]} "#{mail}" "#{printer.name}" "#{params[:body]}" "#{printer.report_path}"`
    end    
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

  def select_all_printers
    @report.printers.each do |printer|
      printer.update(active: true)
    end
    redirect_to @report
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
        path = `python ./public/get_file_path.py`
        path_to_string(path)
        @report.update(report_path: path_to_string(path))
      end
    end

    def get_folder_path
      `python ./public/get_folder_path.py`
    end

    def path_to_string(path)
      start = path.index("'") + 1
      final = path.index(".xlsx") + 4
      path[start..final]
    end

    def make_report(printer, folder_path, data)
      excel_data = []
      headers = []
      printer_path = folder_path + "/" + printer.name + ".xlsx"
      @report.columns.where(active: true).each do |column|
        data.sheets.first.rows.first.each do |data_column|
          headers << data_column if data_column == column.name
        end
      end
      excel_data << headers
      data.sheets.first.rows.each do |row|
        excel_row = []
        if row[@report.filter.to_i] == printer.name
          row.each do |column|
            excel_row << column unless column.nil?
          end
          excel_data << excel_row
        end
      end
      p = Axlsx::Package.new
      wb = p.workbook
      wb.add_worksheet(name: printer.name) do |sheet|
        excel_data.each do |row|
          sheet.add_row row
        end
      end
      printer.update(report_path: printer_path)
      p.serialize(folder_path + "/" + printer.name + ".xlsx") 
    end

end
