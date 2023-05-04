class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string   :name, null: false, limit: 100
      t.decimal  :price, null: false, precision: 10, scale: 2
      t.string   :photo_url, null: false
      t.integer  :status, null: false, default: 1

      t.timestamps
    end
  end
end
