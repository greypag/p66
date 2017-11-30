class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|


      t.string   :f_name
      t.string   :l_name
      t.string   :native_language
      t.string   :email
      t.string   :password
      t.string   :status
      t.string   :token

      t.timestamps
    end
  end
end
