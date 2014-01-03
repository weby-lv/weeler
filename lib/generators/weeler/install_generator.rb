require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Weeler
  module Generators
    class InstallGenerator < Rails::Generators::Base
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

      def install_initializer
        copy_files 'initializers', 'config/initializers'
      end

      def install_migrations
        get_file_list('migrations').each do |migration|
          migration_template "migrations/#{migration}", "db/migrate/#{migration}"
        end
      end

      def install_views
        copy_files 'views', 'app/views'
      end

      def install_javascripts_assets
        copy_files 'assets/javascripts', 'lib/assets/javascripts'
      end

      def install_stylesheets_assets
        copy_files 'assets/stylesheets', 'lib/assets/stylesheets'
      end

      def install_controllers
        copy_files 'controllers', 'app/controllers'
      end

      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true
      def add_weeler_routes
        weeler_routes  = "mount_weeler_at \"weeler\" do \n"
        weeler_routes << "    # weeler_resources :example, include_in_weeler_menu: true \n"
        weeler_routes << "  end"
        route weeler_routes
      end

    private

      def copy_files subdir, dest_dir
        raise ArgumEnterror unless subdir.is_a? String
        raise ArgumEnterror unless dest_dir.is_a? String
        raise ArgumetnError if subdir.blank?
        raise ArgumetnError if dest_dir.blank?

        get_file_list(subdir).each do |image|
          copy_file [subdir, image].join('/'), [dest_dir, image].join('/')
        end
      end

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