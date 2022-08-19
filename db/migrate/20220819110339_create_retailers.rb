class CreateRetailers < ActiveRecord::Migration[7.0]
  def change
    create_table :retailers do |t|
      t.string :name
      t.string :email
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
