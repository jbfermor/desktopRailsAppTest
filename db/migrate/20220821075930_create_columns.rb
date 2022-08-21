class CreateColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :columns do |t|
      t.string :name
      t.boolean :active
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
