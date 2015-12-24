class EnableExtensionUuidOsspInRailsAuthenticationEngine < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp' if ENV['POSTGRESQL_ID'] == 'uuid'
  end
end
