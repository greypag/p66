class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.string  :title
      t.string  :language
      t.string  :industry
      t.string  :level
      t.string  :avatar
      t.integer :type

      t.timestamps
    end
  end
end
