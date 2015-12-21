class CreateUser < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string   :email
      t.string   :password_digest
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps null: false
    end
  end
end
