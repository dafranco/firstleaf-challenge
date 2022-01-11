class AddIndexesToUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :key, unique: true
    add_index :users, :account_key, unique: true
  end
end
