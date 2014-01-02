require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Weeler
  module Generators
    class InstallSeoGenerator < Rails::Generators::Base
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
        get_file_list('migrations/seo').each do |migration|
          migration_template "migrations/seo/#{migration}", "db/migrate/#{migration}"
        end
      end


      private

        def get_file_list subdir
          raise ArgumentError unless subdir.is_a? String
          raise ArgumetnError if subdir.blank?
          dir = get_current_dir
          search_path = [dir, 'templates', subdir].join('/') + '/'
          file_list = Dir.glob(search_path + '**/*').map { |filename| File.directory?(filename) ? nil : filename.sub(search_path, '') }
          file_list.delete nil
          return file_list
        end

        def get_current_dir
          File.dirname(__FILE__)
        end

    end
  end
end