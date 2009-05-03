class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :topic
      t.references :user
      t.string :title, :null => false
      t.text :body
      t.integer :follow_id
      t.string :message_type
      # For comment message use
      t.string :comment_user, :comment_email, :comment_website

      # Record last edit infomation
      t.integer :last_edit_id
      
      # Record the number of user view the message
      t.integer :view_count

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
