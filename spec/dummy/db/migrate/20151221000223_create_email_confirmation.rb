class CreateEmailConfirmation < ActiveRecord::Migration
  def change
    create_table :email_confirmations do |t|
      t.string   :email
      t.string   :token
      t.integer  :user_id

      t.timestamps null: false
    end
  end
end
