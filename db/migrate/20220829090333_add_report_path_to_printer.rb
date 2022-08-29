class AddReportPathToPrinter < ActiveRecord::Migration[7.0]
  def change
    add_column :printers, :report_path, :string
  end
end
