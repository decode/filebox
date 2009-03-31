class CreateMessageboxes < ActiveRecord::Migration
  def self.up
    create_table :messageboxes do |t|
      t.integer :user_id, :message_id, :null => false
      t.string :workflow_state
      t.timestamps
    end
  end

  def self.down
    drop_table :messageboxes
  end
end
