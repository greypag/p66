class ChangeDataTypeQar < ActiveRecord::Migration[5.1]
  def change
    change_column :qars, :rating, :string
  end
end
