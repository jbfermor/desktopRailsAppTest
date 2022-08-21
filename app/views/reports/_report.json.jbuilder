json.extract! report, :id, :name, :columns, :filter, :customer_id, :created_at, :updated_at
json.url report_url(report, format: :json)
