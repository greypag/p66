class CreateTestRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :test_records do |t|
      t.integer   :user_id
      t.integer   :test_id
      t.string    :test_name
      t.string    :language
      t.string    :industry
      t.integer   :status, default: 0
      t.datetime  :start_date
      t.datetime  :purchased_date
      t.string    :score

      t.timestamps
    end
  end
end
