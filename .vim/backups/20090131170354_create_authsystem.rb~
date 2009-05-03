class CreateAuthsystem < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.string :email
      t.timestamps
    end

    create_table :user_sessions do |t|
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end

    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
    end

    create_table :permissions do |t|
      t.string :name, :null => false
      t.string :description
      #t.string :controller_name, :controller_action
      t.string :perm_type, :perm_resource
      t.timestamps
    end

    create_table :permissions_roles, :id => false do |t|
      t.integer :permission_id
      t.integer :role_id
    end

    init_base_relation
  end

  def self.down
    say 'drop users table'
    drop_table :users
    say 'drop user_sessions table'
    drop_table :user_sessions
    say 'drop roles table'
    drop_table :roles
    say 'drop roles_users table'
    drop_table :roles_users
    say 'drop permissions table'
    drop_table :permissions
    say 'drop permissions_roles table'
    drop_table :permissions_roles
  end

  def self.init_base_relation
    say 'create admin role ...'
    role = Role.new
    role.name = "admin"
    role.description = "role for admin"
    role.save!

    say 'create admin user ...'
    user = User.new :login=> "admin", :password=>"admin", :email=>"admin@site.org", :password_confirmation=>"admin" 
    user.roles << role
    user.save

    say 'create anonymous role ...'
    anonymous = Role.new :name=>"anonymous", :description=>"role for unregistered user"
    anonymous.save

    say 'create anonymous user ...'
    user = User.new :login=> "anonymous", :password=>"1234567", :email=>"anonymous@site.org", :password_confirmation=>"1234567" 
    user.roles << anonymous
    user.save
    
    say 'create normal role ...'
    normal = Role.new :name=>"normal", :description=>"role for registered user"
    normal.save

    say 'fetch all controller and action to permission db ...'
    Permission.synchronize_resource
    Permission.find( :all ).each do |p|
      p.roles << role
      p.save
    end

    say 'assign base permission to anonymous role'
    base = Permission.find :first, :conditions => { :perm_resource=>"usersessions", :perm_type=>"C" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/new", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/create", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/show", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/edit", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/index", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base.save

    #base = Permission.find :first, :conditions => { :perm_resource=>"users/create", :perm_type=>"CA" }
    #base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/info", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"users/panel", :perm_type=>"CA" }
    base.roles << normal

    base = Permission.find :first, :conditions => { :perm_resource=>"topics/show", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"topics/index", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/show", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/index", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/new", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/create", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/blog_view", :perm_type=>"CA" }
    base.roles << anonymous
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/edit", :perm_type=>"CA" }
    base.roles << normal
    base = Permission.find :first, :conditions => { :perm_resource=>"messages/update", :perm_type=>"CA" }
    base.roles << normal

    say 'create regular permission for anonymous (also admin)'
    base = Permission.new :name=>"all index", :perm_resource=>"index", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base.roles << normal

    base = Permission.new :name=>"all show", :perm_resource=>"show", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal

    base = Permission.new :name=>"all table", :perm_resource=>"table", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base = Permission.new :name=>"all list", :perm_resource=>"list", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base = Permission.new :name=>"all show_search", :perm_resource=>"show_search", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base = Permission.new :name=>"all row", :perm_resource=>"row", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base = Permission.new :name=>"all nasted", :perm_resource=>"nasted", :perm_type=>"A"
    base.roles << anonymous
    base.roles << role
    base.roles << normal
    base.save
  end

end
