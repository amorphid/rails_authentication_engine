class CreateEmailConfirmation < ActiveRecord::Migration
  def change
    create_table :email_confirmations, id: :uuid do |t|
      t.string   :email
      t.string   :token

      t.timestamps null: false
    end
  end
end
