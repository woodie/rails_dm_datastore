require 'data_mapper/data_mapper_generator'
require 'rails/generators/named_base'

module DataMapper
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase #DataMapperGenerator
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      check_class_collision

      #class_option :migration,  :type => :boolean
      class_option :timestamps, :type => :boolean
      #class_option :parent,     :type => :string, :desc => "The parent class for the generated model"

      #def create_migration_file
      #  return unless options[:migration] && options[:parent].nil?
      #  migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
      #end

      def create_model_file
        puts "I am creating a datamapper model"
        template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      end

      #hook_for :test_framework

      #protected

        #def parent_class_name
        #  options[:parent] || "ActiveRecord::Base"
        #end
        def self.source_root
          puts File.expand_path('../templates', __FILE__)
          @source_root ||= File.expand_path('../templates', __FILE__)
        end
    end
  end
end
