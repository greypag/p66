class CreateQars < ActiveRecord::Migration[5.1]
  def change
    create_table :qars do |t|
      t.string  :title
      t.string  :language
      t.string  :industry
      t.string  :level
      t.string  :prompt
      t.string  :bmr
      t.string  :response
      t.integer :rating

      t.timestamps
    end
  end
end
