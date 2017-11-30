class AddRatingToResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :better_than, :string
    add_column :responses, :as_good_as, :string
    add_column :responses, :worse_than, :string
  end
end
