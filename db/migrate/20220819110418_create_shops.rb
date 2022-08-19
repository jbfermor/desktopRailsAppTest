class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :email
      t.references :retailer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
