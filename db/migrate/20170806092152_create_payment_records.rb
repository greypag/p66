class CreatePaymentRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_records do |t|
      t.string   :payment_id
      t.integer   :user_id
      t.string   :first_name
      t.string   :last_name
      t.string   :payment_method
      t.string   :price
      t.datetime  :payment_time
      t.integer   :test_id
      t.string   :test_name
      t.string   :payment_status

      t.timestamps
    end
  end
end
