class AddRatersToResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :raters, :string
  end
end
