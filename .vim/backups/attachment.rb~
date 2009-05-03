class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  belongs_to :gallary, :counter_cache => true
  has_attached_file :object, :styles => { :medium => "200x200>", :thumb => "100x100>" }

  def to_label
    object_file_name
  end
  
end
