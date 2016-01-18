require 'thor'
require 'rails/generators'
require 'rails/generators/actions'

module RailsAuthenticationEngine
  class InstallGenerator < ::Rails::Generators::Base
    attr_reader :mount_path

    desc 'Installs RailsAuthenticationEngine'

    def install
      sanitize_inputs

      [
        :enable_extension_uuid_ossp_in_rails_authentication_engine,
        :create_rails_authentication_engine_email_confirmations,
        :create_rails_authentication_engine_password_resets,
        :create_user
      ].each do |migration|
        path = Rails.root.join('db', 'migrate', "#{timestamp_counter}_#{migration}.rb")
        create_file path, send(migration)
      end

      route "mount RailsAuthenticationEngine::Engine, at: '#{mount_path}'"
    end

    private

    def create_rails_authentication_engine_password_resets
      <<-MIGRATION
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
      MIGRATION
    end

    def create_rails_authentication_engine_email_confirmations
      <<-MIGRATION
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
      MIGRATION
    end

    def create_user
      <<-MIGRATION
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
      MIGRATION
    end

    def enable_extension_uuid_ossp_in_rails_authentication_engine
      <<-MIGRATION
class EnableExtensionUuidOsspInRailsAuthenticationEngine < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp' if ENV['POSTGRESQL_ID'] == 'uuid'
  end
end
      MIGRATION
    end

    def sanitize_inputs
      sanitize_mount_path
    end

    def sanitize_mount_path
      paths = ARGV.select { |string| string.match(/^mount_path:/) }

      if paths.length > 1
        puts
        puts "Multiple 'mount_path' detected.  Please input 'mount_path:<path>' only once."
        puts
        exit
      end

      @mount_path = if paths.length == 1
        paths.first.split(":").last
      else
        puts
        puts 'You need to specify a mount_path.'
        puts
        puts "Example routes for mount path '/':"
        puts "- sign in           => /sign_in"
        puts "- sign up           => /sign_up"
        puts "- password recovery => /password_recovery"
        puts
        puts "Example routes for mount path '/foo':"
        puts "- sign in           => /foo/sign_in"
        puts "- sign up           => /foo/sign_up"
        puts "- password recovery => /foo/password_recovery"
        puts
        print "Specify mount path (hit enter for default '/'):  "
        input = gets.chomp

        input.match(/^\//) ? input : "/#{input}"
      end
    end

    def timestamp_counter
      @timestamp_counter ||= DateTime.now.utc.strftime('%Y%m%d%H%M%S').to_i
      @timestamp_counter += 1
    end
  end
end
