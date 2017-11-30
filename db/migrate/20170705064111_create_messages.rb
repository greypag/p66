class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string   :user_id
      t.string   :to_user_id
      t.integer  :is_system_notification, default: 0
      t.string   :subject
      t.string   :content
      t.string   :email
      t.string   :from_email

      t.timestamps
    end
  end
end
