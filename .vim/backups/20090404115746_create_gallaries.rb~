class CreateGallaries < ActiveRecord::Migration
  def self.up
    create_table :gallaries do |t|
      t.references :user
      t.string :name
      t.integer :attachments_count
      t.integer :password
      t.boolean :ispublic
      t.boolean :isfriend
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :gallaries
  end
end
