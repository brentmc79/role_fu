class RoleFuGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.class_collisions "role", "role_mapping"
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_roles_and_role_mappings"
    end
  end
end
