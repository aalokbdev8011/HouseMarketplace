class ChangeJtiNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :jti, :string, null: true
  end
end
