class CreatePrompts < ActiveRecord::Migration[5.1]
  def change
    create_table :prompts do |t|
      t.string  :title
      t.string  :language
      t.string  :industry
      t.string  :level
      t.string  :bmr
      t.text  :text
    end
  end
end
