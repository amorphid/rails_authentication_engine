class CreateRailsAuthenticationEngineEmailConfirmations < ActiveRecord::Migration
  def change
    create_table *([
      :rails_authentication_engine_email_confirmations,
      ({ id: :uuid } if ENV['POSTGRESQL_ID'] == 'uuid')
    ]).compact  do |t|
      t.string :email
      t.string :token

      t.timestamps null: false
    end
  end
end
