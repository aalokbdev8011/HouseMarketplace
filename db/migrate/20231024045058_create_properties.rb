# frozen_string_literal: true

class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.decimal :price
      t.string :address
      t.integer :rooms
      t.string :mrt_station
      t.string :property_type

      t.timestamps
    end
  end
end
