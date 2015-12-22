class CreateRailsAuthenticationEnginePasswordResets < ActiveRecord::Migration
  def change
    create_table :rails_authentication_engine_password_resets, id: :uuid do |t|
      t.string :token
      t.uuid :email_confirmation_id

      t.timestamps null: false
    end
  end
end
