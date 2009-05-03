class Gallary < ActiveRecord::Base
  belongs_to :user
  has_many :attachments, :class_name => '::Attachment', :conditions => "object_content_type = 'image/jpeg'", :dependent => :destroy
end
