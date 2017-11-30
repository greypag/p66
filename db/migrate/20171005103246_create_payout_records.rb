class CreatePayoutRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :payout_records do |t|
      t.integer  :rater_id
      t.string  :payout_status
      t.string  :payout_id
      t.string  :amount
      t.string  :payout_item_fee

      t.timestamps
    end
  end
end
