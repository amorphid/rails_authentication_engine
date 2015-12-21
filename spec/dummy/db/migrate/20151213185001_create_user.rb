class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email
      t.string   :password_digest
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps null: false
    end
  end
end
