class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE user_role AS ENUM ('admin', 'moderator', 'user');
    SQL
    add_column :users, :role, :user_role
    add_index :users, :role
  end

  def down
    remove_column :users, :role
    execute <<-SQL
      DROP TYPE user_role;
    SQL
  end
end
