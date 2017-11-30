class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.text :description
      t.string :price
      t.string :time

      t.timestamps
    end
  end
end
