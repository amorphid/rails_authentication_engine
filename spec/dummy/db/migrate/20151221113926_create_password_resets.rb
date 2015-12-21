class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets, id: :uuid do |t|
      t.string :token
      t.uuid   :email_confirmation_id

      t.timestamps null: false
    end
  end
end
