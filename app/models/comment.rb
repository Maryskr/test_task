class Comment < ActiveRecord::Base
  validates_presence_of :user_name, :user_email, :content
  validates_format_of :user_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :children, :class_name => "Comment", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Comment"

  belongs_to :article
end