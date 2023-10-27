class AddIsFavoriteColumnToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :is_favorite, :boolean, default: false
  end
end
