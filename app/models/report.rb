class Report < ApplicationRecord
  belongs_to :customer
  has_many :columns, dependent: :destroy
  has_many :printers, dependent: :destroy

  def get_data
    if self.path && self.columns.empty?
      doc = SimpleXlsxReader.open(self.path)
      doc.sheets.first.rows.first.each do |column|
        Column.create(name: column, report_id: self.id, active: true)
      end
    end
  end

  def get_filtered_data(filter)
    delete_printers
    doc = SimpleXlsxReader.open(self.path)
    data = doc.sheets.first.rows
    data.each do |row|  
      Printer.create(name: row[filter.to_i], report_id: self.id, active: true)   
    end
    puts self.printers.order(:id).first.delete
  end

  def delete_printers
    self.printers.each do |printer|
      printer.delete
    end
  end
end
