begin
  require 'rails'
  require 'rails/generators/base'

  class Less::InteractionGenerator < Rails::Generators::NamedBase
    source_root File.join(File.dirname(__FILE__), "templates")

    def create_interaction
      template 'interaction.rb', File.join('app/interactions', class_path, "#{file_name}.rb")
    end

    def create_test
      template 'test.rb', File.join('test/interactions', class_path, "#{file_name}_test.rb")
    end
  end
rescue LoadError
end