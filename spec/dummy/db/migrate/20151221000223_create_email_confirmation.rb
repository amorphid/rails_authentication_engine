class CreateEmailConfirmation < ActiveRecord::Migration
  def change
    create_table :email_confirmations do |t|
      t.datetime :sent_at
      t.string   :token
      t.integer  :user_id

      t.timestamps
    end
  end
end
