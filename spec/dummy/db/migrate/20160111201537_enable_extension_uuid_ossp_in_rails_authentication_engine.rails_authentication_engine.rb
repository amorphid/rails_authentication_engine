# This migration comes from rails_authentication_engine (originally 20151222140946)
class EnableExtensionUuidOsspInRailsAuthenticationEngine < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp' if ENV['POSTGRESQL_ID'] == 'uuid'
  end
end
