class Subcomment < ActiveRecord::Base
  validates_presence_of :parent_id, :child_id, :deeps

  belongs_to :comment
  belongs_to :child, :class_name => 'Comment',  foreign_key: "child_id"
end