class CreateRolesAndRoleMappings < ActiveRecord::Migration
  def self.up
    create_table "roles", :force => true do |t|
      t.string :name, :null => false
      t.integer :parent_id
      t.timestamps
    end
    
    create_table "role_mappings", :force => true do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :roles
    drop_table :role_mappings
  end
end
