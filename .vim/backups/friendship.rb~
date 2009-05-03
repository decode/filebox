class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'

  include Workflow
  workflow do
    state :request do
      event :approve, :transitions_to => :accept
      event :deny, :transitions_to => :refuse
      event :block, :transitions_to => :block
    end
    state :accept do
      event :block, :transitions_to => :block
      event :delete, :transitions_to => :delete
    end
    state :refuse do
      event :block, :transitions_to => :block
      event :delete, :transitions_to => :delete
      event :approve, :transitions_to => :accept
    end
    state :block do
      event :delete, :transitions_to => :delete
      event :approve, :transitions_to => :accept
    end
    state :delete
  end
end
