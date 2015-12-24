class CreateUser < ActiveRecord::Migration
  def change
    create_table *([
      :users,
      ({ id: :uuid } if ENV['POSTGRESQL_ID'] == 'uuid')
    ]).compact  do |t|
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
