class AddPaypalReceiverToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :recipient_type, :string
    add_column :users, :receiver, :string
  end
end
