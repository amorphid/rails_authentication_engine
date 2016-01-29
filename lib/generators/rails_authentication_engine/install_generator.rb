require 'thor'
require 'rails/generators'
require 'rails/generators/actions'

module RailsAuthenticationEngine
  class InstallGenerator < ::Rails::Generators::Base
    attr_reader :database_id_type, :mount_path

    desc 'Installs RailsAuthenticationEngine'

    def install
      sanitize_inputs

      [
        (:enable_extension_uuid_ossp_in_rails_authentication_engine if database_id_type == 'uuid'),
        :create_rails_authentication_engine_email_confirmations,
        :create_rails_authentication_engine_password_resets,
        :create_user
      ].compact.each do |migration|
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
    create_table :rails_authentication_engine_password_resets#{", {id: :" + database_id_type +  "}" if database_id_type == "uuid"} do |t|
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
    create_table :rails_authentication_engine_email_confirmations#{", {id: :" + database_id_type +  "}" if database_id_type == "uuid" } do |t|
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
    create_table :users#{", {id: :" + database_id_type +  "}" if database_id_type == "uuid" } do |t|
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
      puts
      puts '-----RailsAuthenticationEngine intaller-----'

      sanitize_mount_path
      sanitize_database_id_type
    end

    def sanitize_mount_path
      paths = ARGV.select { |string| string.match(/^mount_path/) }

      if paths.length > 1
        puts
        puts ">> mount_path <<"
        puts
        puts
        puts "Multiple 'mount_path' inuts detected.  Please input 'mount_path:<path>' only once."
        puts
        exit
      end

      if paths.first == 'mount_path' || paths.first == 'mount_path:'
        puts
        puts ">> mount_path <<"
        puts
        puts "'#{paths.first}' is invalid syntax."
        puts
        puts "Examples for valid mount_path syntax:"
        puts "- mount_path for '/'    => mount_path:/"
        puts "- mount_path for '/foo' => mount_path:/foo"
        puts
        exit
      end

      @mount_path = if paths.length == 1
        paths.first.split(":").last
      else
        puts
        puts ">> mount_path <<"
        puts
        puts 'You need to specify a mount_path.'
        puts
        puts "Example routes for mount_path '/':"
        puts "- sign in           => /sign_in"
        puts "- sign up           => /sign_up"
        puts "- password recovery => /password_recovery"
        puts
        puts "Example routes for mount_path '/foo':"
        puts "- sign in           => /foo/sign_in"
        puts "- sign up           => /foo/sign_up"
        puts "- password recovery => /foo/password_recovery"
        puts
        print "Specify mount_path (hit enter for default '/'):  "
        input = gets.chomp

        input.match(/^\//) ? input : "/#{input}"
      end
    end

    def sanitize_database_id_type
      paths = ARGV.select { |string| string.match(/^database_id_type/) }

      if paths.length > 1
        puts
        puts  ">> database_id_type <<"
        puts
        puts "Multiple 'database_id_type' inputs detected.  Please input 'database_id_type:<type>' only once."
        puts
        exit
      end

      if paths.first == 'database_id_type' || paths.first == 'database_id_type:'
        puts
        puts  ">> database_id_type <<"
        puts
        puts "'#{paths.first}' is invalid syntax."
        puts
        puts "Examples for valid database_id_type syntax:"
        puts "- integer => database_id_type:integer"
        puts "- uuid    => database_id_type:uuid"
        puts
        exit
      end

      if ActiveRecord::Base.connection.instance_values["config"][:adapter] != "postgresql" && paths.first == 'database_id_type:uuid'
        puts
        puts  ">> database_id_type <<"
        puts
        puts "This installer only supports UUID primary keys for 'postgresql' (you're using '#{ActiveRecord::Base.connection.instance_values["config"][:adapter]}')."
        puts
        puts "If you want to use UUID primary keys, do one of the following:"
        puts "- edit the migratinons manually"
        puts "- switch to postgresql"
        puts
        exit
      end

      @database_id_type = if paths.first == 'database_id_type:integer' || paths.first == 'database_id_type:uuid'
        paths.first.split(":").last
      else
        puts
        puts  ">> database_id_type <<"
        puts
        puts "You need to specify a database_id_type"
        puts
        puts "Supported types"
        puts "- integer"
        puts "- uuid"
        puts
        print "Specify database_id_type (hit enter for default 'integer'):  "

        input = STDIN.gets.chomp

        if input.blank?
          input = 'integer'
        else
          until input == 'integer' || input == 'uuid'
            puts
            puts "'#{input} is not a supported type."
            puts
            puts "Supported types"
            puts "- integer"
            puts "- uuid"
            puts
            print "Specify database_id_type (hit enter for default 'integer'):  "
            input = STDIN.gets.chomp

            input = 'integer' if input.blank?
          end
        end

        input
      end
    end

    def timestamp_counter
      @timestamp_counter ||= DateTime.now.utc.strftime('%Y%m%d%H%M%S').to_i
      @timestamp_counter += 1
    end
  end
end
