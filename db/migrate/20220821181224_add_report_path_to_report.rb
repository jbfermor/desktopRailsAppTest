class AddReportPathToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :report_path, :string
  end
end
