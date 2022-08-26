# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_21_181224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "columns", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.bigint "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_columns_on_report_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "printers", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.bigint "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_printers_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name"
    t.string "filter"
    t.string "path"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_path"
    t.index ["customer_id"], name: "index_reports_on_customer_id"
  end

  create_table "retailers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_retailers_on_customer_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "retailer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["retailer_id"], name: "index_shops_on_retailer_id"
  end

  add_foreign_key "columns", "reports"
  add_foreign_key "printers", "reports"
  add_foreign_key "reports", "customers"
  add_foreign_key "retailers", "customers"
  add_foreign_key "shops", "retailers"
end
