class Messagebox < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  include Workflow

  workflow do
    state :unread do
      event :read, :transitions_to => :open
      event :msg_delete, :transitions_to => :suspend
      event :delete_forever, :transitions_to => :msg_delete
      event :move, :transitions_to => :open
    end
    state :open do
      event :msg_delete, :transitions_to => :suspend
    end
    state :suspend do
      event :undelete, :transitions_to => :open
      event :delete_forever, :transitions_to => :msg_delete
      event :move, :transitions_to => :open
    end
    state :msg_delete
    state :suspend
  end
=begin
  attr_accessor :state
  record_status = "unread"

  state_machine :initial => :unread do
    event :read do
      transition :unread => :open
    end

    event :msg_delete do
      transition [:unread, :open] => :suspend
    end

    event :undelete do
      transition :suspend => record_status.to_sym if record_status != :delete.to_s
    end

    event :delete_forever do
      transition [:unread, :open, :suspend] => :msg_delete
    end

    state :unread do
      record_status = "unread" 
    end
    state :open do 
      record_status = "open" 
    end
    state :suspend do
      record_status = "suspend" 
    end
    state :undelete do
      record_status = "undelete" 
    end
    state :msg_delete do
      record_status = "msg_delete" 
    end
  end

  def after_initialize
    @state = "unread"
  end
=end
end
