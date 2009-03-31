class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :topic
      t.references :user
      t.string :title, :null => false
      t.text :body
      t.integer :follow_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
