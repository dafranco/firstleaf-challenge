class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, limit: 200, null: false
      t.string :phone_number, limit: 200, null: false,
      t.string :full_name, limit: 200
      t.string :password_digest, limit: 100, null: false
      t.string :key, limit: 100, null: false,
      t.string :account_key, limit:100
      t.string :metadata, limit:2000

      t.timestamps
    end
  end
end
