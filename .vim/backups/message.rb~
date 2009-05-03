class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :follow_message, :class_name => "Message", :foreign_key => "follow_id"
  has_many :follow_messages, :class_name => "Message", :order => 'created_at ASC', :foreign_key => "follow_id"

  belongs_to :user, :foreign_key => :user_id

  has_many :messagebox, :foreign_key => "message_id"
  has_many :receivers, :through => :messagebox, :source => :user
  
  belongs_to :last_edit_user, :class_name => "User", :foreign_key => "last_edit_id"

=begin
  def self.handle(messages)
    messages.each do |msg_id|
      msg = Messagebox.find_by_message_id(msg_id)
      yield(msg)
      msg.save
    end unless messages.nil?
  end
=end
  
  def handle(user, messages)
    messages.each do |msg_id|
      msg = Messagebox.find :first, :conditions => ["message_id=? and user_id =?", msg_id, user.id]
      yield(msg)
      msg.save
    end unless messages.nil?
  end
end
