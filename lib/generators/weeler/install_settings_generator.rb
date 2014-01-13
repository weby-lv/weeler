require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Weeler
  module Generators
    class InstallSettingsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr =  ActiveRecord::Generators::Base.next_migration_number(path).to_i
        else
          @prev_migration_nr += 1
        end

        @prev_migration_nr.to_s
      end

      source_root File.expand_path('../templates', __FILE__)

      def install_migrations
        migration_template "migrations/create_weeler_settings.rb", "db/migrate/create_weeler_settings"
      end

    end
  end
end