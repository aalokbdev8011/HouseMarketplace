# frozen_string_literal: true

class AddCityAndDistrictColumnToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :city, :string
    add_column :properties, :district, :string
  end
end
