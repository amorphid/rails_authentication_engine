class CreateRailsAuthenticationEnginePasswordResets < ActiveRecord::Migration
  def change
    create_table *([
      :rails_authentication_engine_password_resets,
      ({ id: :uuid } if ENV['POSTGRESQL_ID'] == 'uuid')
    ]).compact  do |t|
      t.string :token
      ENV['POSTGRESQL_ID'] == 'uuid' ? (t.uuid :email_confirmation_id) : (t.integer :email_confirmation_id)

      t.timestamps null: false
    end
  end
end
